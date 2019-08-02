#
# Cookbook:: chef-server
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
python_pkgs = [
  'python-pip',
  'python-dev',
]
python_pkgs.each do |pkg|
  apt_package pkg do
    action :install
  end
end

# curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
remote_file '/tmp/get-pip.py' do
  source 'https://bootstrap.pypa.io/get-pip.py'
  mode '0755'
  action :create
end

execute 'install_pip' do
  command 'python /tmp/get-pip.py'
end

pip 'awscli' do
  action :install
end
