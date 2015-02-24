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

firewall_rule "http" do
  protocol :tcp
  port 80
  action :allow
end

package "nginx" do
  action :install
end

service "nginx" do
  action [:enable, :start]
end

template "/etc/nginx/sites-available/davical" do
  source "nginx_configuration.erb"
  variables configuration: {server_name: node[:davical][:server_name] }
  notifies :reload, "service[nginx]"
  action :create
end

link "/etc/nginx/sites-enabled/davical" do
  to "/etc/nginx/sites-available/davical"
  action :create
end

service "postgresql" do
  action :start
end

cookbook_file "/etc/postgresql/9.1/main/pg_hba.conf" do
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :restart, "service[postgresql]", :immediately
  action :create
end

execute "create-database.sh" do
  command "./create-database.sh"
  user "postgres"
  cwd "/usr/share/davical/dba"
  action :run
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
  action :create
end
