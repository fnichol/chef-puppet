#
# Cookbook Name:: puppet
# Attributes:: default
#
# Copyright 2012, Fletcher Nichol
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

node.default['puppet']['master_conf']['main']['logdir']      = '/var/log/puppet'
node.default['puppet']['master_conf']['main']['vardir']      = '/var/lib/puppet'
node.default['puppet']['master_conf']['main']['ssldir']      = '/var/lib/puppet/ssl'
node.default['puppet']['master_conf']['main']['rundir']      = '/var/run/puppet'
node.default['puppet']['master_conf']['main']['factpath']    = '$vardir/lib/facter'
node.default['puppet']['master_conf']['main']['templatedir'] = '$confdir/templates'

node.default['puppet']['master_conf']['master']['ssl_client_header']        = 'SSL_CLIENT_S_DN'
node.default['puppet']['master_conf']['master']['ssl_client_verify_header'] = 'SSL_CLIENT_VERIFY'
