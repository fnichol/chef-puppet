#
# Cookbook Name:: puppet
# Recipe:: aws
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

# Fix up the hostname so it matches the public DNS name of the server.
# This is required for authentication and registering new clients.
execute "hostname #{node['ec2']['public_hostname']}"

case node['platform_family']
when 'debian'
  template '/etc/hostname' do
    source 'hostname.erb'
  end
when 'rhel'
  execute "perl -p -i -e 's/^HOSTNAME=.*/HOSTNAME=#{node['ec2']['public_hostname']}/' /etc/sysconfig/network"
end
