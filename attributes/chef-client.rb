default['chef-client']['interval']  = '900'
default['chef-client']['splay']  = '300'
default['chef-client']['log_dir']   = '/var/log/chef'
default['chef-client']['log_file']  = 'chef-client.log'

default['chef-client']['config']['chef_server_url'] = 'https://chef.cerny.cc/organizations/cerny'
default['chef-client']['config']['ssl_verify_mode'] = ':verify_peer'
