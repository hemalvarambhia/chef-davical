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

package "php5-curl" do
  action :install
end

package "nginx" do
  action :install
end

service "nginx" do
  action [:enable, :start]
end

template "/etc/nginx/sites-available/davical" do
  source "nginx_configuration.erb"
  action :create
end