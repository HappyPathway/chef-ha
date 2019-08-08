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

execute 'pip_install' do
  command 'pip install awscli'
  action :run
end


include_recipe '::install_backend'
include_recipe '::join_cluster'
# include_recipe '::install_frontend'
