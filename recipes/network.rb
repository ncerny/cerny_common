#
# Cookbook Name:: cerny_common
# Recipe:: network
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
#
# rubocop:disable LineLength

return unless %w(ceph01.cerny.cc ceph02.cerny.cc ceph03.cerny.cc).include?(node['fqdn'])

package 'net-tools'

file '/tmp/reboot' do
  action :delete
end

%w(ifcfg-enp1s0f0 ifcfg-enp1s0f1 ifcfg-bridge-slave-enp2s0f0 ifcfg-bridge-slave-enp2s0f1 ifcfg-bridge-clbr0 ifcfg-vlan17).each do |dev|
  cookbook_file "/etc/sysconfig/network-scripts/#{dev}" do
    action :create
    source dev
    owner 'root'
    group 'root'
    mode '0640'
    notifies :touch, 'file[/tmp/reboot]', :immediately
  end
end

cookbook_file '/etc/NetworkManager/dispatcher.d/99-mtu' do
  action :create
  source 'mtu-dispatcher'
  owner 'root'
  group 'root'
  mode '0750'
  notifies :restart, 'service[network]', :delayed
end

cookbook_file '/etc/udev/rules.d/60-persistent-net.rules' do
  action :create
  source 'persistent-net.rules'
  owner 'root'
  group 'root'
  mode '0640'
  notifies :touch, 'file[/tmp/reboot]', :immediately
end

reboot 'network-configuration' do
  action :reboot_now
  reason 'Reboot to pick up network changes'
  delay_mins 0
  only_if { File.exist?('/tmp/reboot') }
end

service 'network' do
  action :nothing
  supports [:start, :stop, :status, :restart]
end

# rubocop:enable LineLength
