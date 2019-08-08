execute 'install_chef' do
  command "bash /tmp/chef-install.sh -s -- -P chef-server -d /tmp -v #{node['chef_backend_version']}"
  action :run
end

directory '/etc/opscode/' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'gen_server_config' do
  command "chef-backend-ctl gen-server-config #{node.name} > /etc/opscode/chef-server.rb"
  action :run
end


execute 'download_secrets_file' do
  command "aws s3 cp s3://#{node['chef_config_bucket']}/#{node['chef_config_path']}/private-chef-secrets.json /etc/opscode/private-chef-secrets.json"
  action :run
end

directory '/var/opt/opscode/upgrades' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'download_secrets_file' do
  command "aws s3 cp s3://#{node['chef_config_bucket']}/#{node['chef_config_path']}/migration-level /var/opt/opscode/upgrades/migration-level"
  action :run
end

file '/var/opt/opscode/bootstrapped' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'chef_server_reconfig' do
  command '"chef-server-ctl reconfigure"'
  action :run
end
