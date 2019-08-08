apt_update 'update-apt' do
  ignore_failure true
  action :update
end

apt_package 'ntp' do
  action :install
end

remote_file '/tmp/chef-install.sh' do
  source 'https://omnitruck.chef.io/install.sh'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'install_chef' do
  command "bash /tmp/chef-install.sh -s -- -P chef-backend -d /tmp -v #{node['chef_backend_version']}"
  action :run
  ignore_failure true
end

directory '/etc/chef-backend' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template '/etc/chef-backend/chef-backend.rb' do
  source 'chef-backend.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

execute 'download_secrets_file' do
  command "aws s3 cp s3://#{node['chef_config_bucket']}/#{node['chef_config_path']}/chef-backend-secrets.json /etc/chef-backend/chef-backend-secrets.json"
  action :run
end

execute 'configure_chef' do
  command 'chef-backend-ctl reconfigure'
  action :run
  ignore_failure true
end

execute 'join_cluster' do
  command "chef-backend-ctl join-cluster #{node['chef_cluster_master']} --accept-license --yes"
  action :run
end
