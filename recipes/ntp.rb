#
# Cookbook Name:: cerny_common
# Recipe:: ntp
#
# Copyright 2015 Nathan Cerny
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
# rubocop:disable LineLength

# From old base recipe.
# ntpservers = []
# ntp_servers = search(:node, 'tags:ntp_server')
# ntp_servers.each do |ntp_server|
#   ntpservers << ntp_server.fqdn
# end
#
# if tagged?('ntp_server')
#   node.force_default['ntp']['servers'] = [
#     '0.north-america.pool.ntp.org',
#     '1.north-america.pool.ntp.org',
#     '2.north-america.pool.ntp.org',
#     '3.north-america.pool.ntp.org'
#   ]
#   node.default['ntp']['peers'] = ntpservers
#   node.default['ntp']['is_server'] = 'true'
#   node.default['ntp']['restrictions'] = [
#     '192.168.100.0 255.255.255.0 nomodify notrap',
#     '192.168.101.0 255.255.255.0 nomodify notrap',
#     '192.168.102.0 255.255.255.0 nomodify notrap',
#     '192.168.103.0 255.255.255.0 nomodify notrap'
#   ]
# else
#   node.default['ntp']['servers'] = ntpservers
#   node.default['ntp']['is_server'] = 'false'
# end
#
# include_recipe 'ntp'

log 'last_sync' do
  level :error
  message "Last Sync: #{node['ntp']['last_sync']}"
end

# Force a sync of the clock every 7 days (give or take ~15 minutes)
if node['ntp']['last_sync'].nil? || (DateTime.now - DateTime.parse(node['ntp']['last_sync'])).to_f >= 6.99
  unless node['virtualization'] && node['virtualization']['role'] == 'guest'
    node.default['ntp']['sync_hw_clock'] = true
  end
  node.default['ntp']['sync_clock'] = true
  node.normal['ntp']['last_sync'] = DateTime.now
end
include_recipe 'ntp'

# rubocop:enable LineLength
