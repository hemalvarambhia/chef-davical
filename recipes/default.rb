#
# Cookbook Name:: chef-davical
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apt::default"

package "davical" do
  action :install
end

include_recipe "chef-davical::web_server"

include_recipe "chef-davical::database"

package "php5-curl" do
  action :install
end

if node.platform_version == "10.04"
  package "python-software-properties" do
    action :install
  end

  apt_repository "brianmercer-php" do
    uri "http://ppa.launchpad.net/brianmercer/php/ubuntu"
    distribution node[:lsb][:codename]
    components ["main"]
    keyserver "keyserver.ubuntu.com"
    key "8D0DC64F"
    action :add
  end

  package "php5-fpm" do
    action :install
  end
end

service "php5-fpm" do
  action :start
end

davical_configuration = {
    domain_name: node[:davical][:server_name],
    admin_email: node[:davical][:system_email],
    local_time_zone: node[:davical][:time_zone],
    system_name: node[:davical][:system_name]
}
template "/etc/davical/config.php" do
  source "config.php.erb"
  variables davical_configuration
  mode 0644
  notifies :restart, "service[php5-fpm]"
  action :create
end
