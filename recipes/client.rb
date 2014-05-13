#
# Cookbook Name:: puppet
# Recipe:: client
#
# Copyright 2014, Sean CArolan
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

# Installs the puppet client and starts up puppet agent
majver = node['platform_version'].split(".")[0]

case node['platform_family']
when 'debian'
  apt_repository "puppetlabs" do
    uri           "http://apt.puppetlabs.com/"
    distribution  node['lsb']['codename']
    components    ["main"]
    key           "http://apt.puppetlabs.com/pubkey.gpg"
  end
when 'rhel'
  remote_file "#{Chef::Config[:file_cache_path]}/puppetlabs-release-el-#{majver}.noarch.rpm" do
    source "http://yum.puppetlabs.com/puppetlabs-release-el-#{majver}.noarch.rpm"
  end

  package "puppetlabs-release-el-#{majver}" do
    source "#{Chef::Config[:file_cache_path]}/puppetlabs-release-el-#{majver}.noarch.rpm"
  end
end

package 'puppet' do
  action :install
end

template '/etc/puppet/puppet.conf' do
  source  'puppet.conf.erb'
  mode    '0644'
  variables(:conf => node['puppet']['client_conf'])
end

# Runs puppet agent
# execute 'puppet agent -t' do
#   returns [0, 2]
# end

# Starts the puppet agent service 
# service 'puppet' do
#   action [ :start, :enable ]
# end
