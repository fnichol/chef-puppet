#
# Cookbook Name:: puppet
# Recipe:: whitelist
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

# Configures the Puppet server's whitelist, which allows new clients
# to auto-register.
template '/etc/puppet/autosign.conf' do
  source 'autosign.conf.erb'
  mode '0644'
  variables(
    :whitelist => node['puppet']['autosign']['whitelist']
  )
end
