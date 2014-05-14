#
# Cookbook Name:: puppet
# Recipe:: loadtest
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

# TODO:  Write code that puts some stress on the Puppet server.

template '/etc/puppet/manifests/modules.pp' do
  source 'modules.pp.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(
    :modules => node['puppet']['modules']['install']
  )
end

template '/etc/puppet/manifests/nodes.pp' do
  source 'nodes.pp.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(
    :modules => node['puppet']['modules']['loadtest']
  )
end

template '/etc/puppet/manifests/site.pp' do
  source 'site.pp.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(
    :hostname => node['ec2']['public_hostname']
  )
end

node['puppet']['modules']['install'].each do |mod|
  execute "puppet module install puppetlabs-#{mod} --force"
end
