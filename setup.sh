#!/bin/bash
wget https://packages.chef.io/files/stable/chef/14.12.9/ubuntu/18.04/chef_14.12.9-1_amd64.deb
dpkg -i chef_14.12.9-1_amd64.deb
chef-solo -c /tmp/chef/solo.rb -j /tmp/chef/nodes/ip-10-0-7-21.ec2.internal.json --chef-license accept --environment=_default -N ip-10-0-7-21.ec2.internal