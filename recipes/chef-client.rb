#
# Cookbook Name:: cerny_common
# Recipe:: chef-client
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

# return if we're running in local mode.
return unless File.exist?('/etc/chef/client.rb')

include_recipe 'chef-client::config'

execute 'import-chef-ssl-cert' do
  command '/usr/bin/knife ssl fetch -c /etc/chef/client.rb'
  not_if '/usr/bin/knife ssl check -c /etc/chef/client.rb'
end

include_recipe 'chef-client'
include_recipe 'chef-client::delete_validation'
