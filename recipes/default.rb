#
# Cookbook Name:: chef-davical
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apt::default"

include_recipe "yum-epel::default" if node.platform == "centos"

include_recipe "chef-davical::davical"

include_recipe "chef-davical::web_server"

include_recipe "chef-davical::database"

include_recipe "chef-davical::php_packages"

if node.platform_version == "10.04"
  ruby_block "symbolic_links_to_awl_files" do
    block do
      require 'fileutils'
      Dir.glob("#{node[:awl][:dir]}/inc/*").each do |awl_file|
        corresponding_davical_sym_link = "#{node[:davical][:dir]}/inc/#{File.basename(awl_file)}"
        unless File.symlink?(corresponding_davical_sym_link)
          FileUtils.ln_s(awl_file, corresponding_davical_sym_link)
        end
      end
    end
    action :run
  end
end

php_fpm = if node.platform == "ubuntu"
            "php5-fpm"
          else
            "php-fpm"
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
  notifies :restart, "service[#{php_fpm}]"
  action :create
end
