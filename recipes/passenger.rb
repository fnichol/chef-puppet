#
# Cookbook Name:: puppet
# Recipe:: master
#
# Copyright 2014, Sean Carolan
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

log 'Generating server SSL cert' do
  message 'Running puppet agent to generate cert.'
end

# The puppet agent must be run at least once to generate the server's SSL cert
execute "puppet agent --waitforcert 60 -t" do
  not_if { File.exist?("/var/lib/puppet/ssl/certs/#{node['puppet']['client_conf']['main']['server']}") }
  returns [0, 2]
  timeout 120
end

# Stop and disable the WEBrick puppetmaster
service 'puppetmaster' do
  action [ :stop, :disable ]
end

# Install prerequisites and Ruby gems during compile phase
node['puppet']['passenger']['packages'].each do |pack|
  p = package pack do
    action :nothing
  end
  p.run_action(:install)
end

node['puppet']['passenger']['gems'].each do |rubygem|
  r = gem_package rubygem do
    action :nothing
  end
  r.run_action(:install)
end

# Fetch the Phusion Passenger version
# This must be done after passenger is installed!
node.default['puppet']['passenger']['version'] = `passenger -v 2>&1 | head -1 | awk '{ print $4 }'`.chomp

# Enable mod_ssl, configure puppet apache vhost
case node['platform_family']
when 'debian'
  apachename = 'apache2'
  execute 'a2enmod ssl; a2enmod headers'
  template '/etc/apache2/sites-available/puppet.conf' do
    source 'puppet_vhost.conf.erb'
    owner 'puppet'
    group 'puppet'
    action :create
  end
  execute 'a2ensite puppetmaster'
when 'rhel'
  apachename = 'httpd'
  template '/etc/httpd/conf.d/puppet.conf' do
    source 'puppet_vhost.conf.erb'
    owner 'puppet'
    group 'puppet'
    action :create
    variables(
      :passenger_version => node['puppet']['passenger']['version']
    )
  end

  # These apache modules are required for it to start
  modules = %w(ssl headers)
  modules.each do |mod|
    template "/etc/httpd/conf.d/#{mod}.load" do
      source "#{mod}.load.erb"
      owner 'puppet'
      group 'puppet'
      action :create
    end
  end
end

# Install the passenger module
log 'Installing Passenger Module' do
  message 'Installing the Apache Phusion Passenger module. This may take a while...'
end

execute 'passenger-install-apache2-module'

dirs = %w(public tmp)
dirs.each do |dir|
  directory "/usr/share/puppet/rack/puppetmasterd/#{dir}" do
    action :create
    recursive true
    owner 'puppet'
    group 'puppet'
  end
end

template '/usr/share/puppet/rack/puppetmasterd/config.ru' do
  action :create
  source 'config.ru.erb'
  owner 'puppet'
  group 'puppet'
end

# Fix permissions and disable SELinux
execute 'chown -R puppet:puppet /usr/share/puppet'
execute 'echo "0" /selinux/enforce'

# Finally we can start up Apache with the passenger module enabled.
# And they said Chef was hard!
service apachename do
  action [ :enable, :restart ]
end
