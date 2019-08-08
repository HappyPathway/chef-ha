#!/bin/bash
wget https://packages.chef.io/files/stable/chef/${chef_version}/ubuntu/${os_version}/chef_14.12.9-1_amd64.deb
dpkg -i chef_14.12.9-1_amd64.deb
chef-solo -c /tmp/chef/solo.rb -j /tmp/chef/nodes/${nodename}.json --chef-license accept --environment=${chef_environment} -N ${nodename}