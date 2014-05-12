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

# Stop and disable the WEBrick puppetmaster
service 'puppetmaster' do
  action [ :stop, :disable ]
end

# Install prerequisites and Ruby gems
node['puppet']['passenger']['packages'].each do |pack|
  package pack
end

node['puppet']['passenger']['gems'].each do |rubygem|
  gem_package rubygem
end

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
end

# Install the passenger module
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

service apachename do
  action [ :enable, :start ]
end
