#
# Cookbook Name:: chef-davical
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node.platform_family
  when "debian"
    include_recipe "apt::default"
  when "rhel"
    include_recipe "yum-epel::default"
end

package "davical" do
  action :install
end
