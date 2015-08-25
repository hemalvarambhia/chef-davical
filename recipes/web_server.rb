firewall_rule "http" do
  protocol :tcp
  port 80
  action :allow
end

if node.platform_version == "10.04" or node.platform_version == "14.04"
  service "apache2" do
    action :stop
  end

  package "apache2" do
    action :remove
  end
end

package "nginx" do
  action :install
end

service "nginx" do
  action [:enable, :start]
end

conf_dir = if node.platform == "ubuntu"
             "/etc/nginx/sites-available"
           else
             "/etc/nginx/conf.d"
           end

template "#{conf_dir}/davical" do
  source "nginx_configuration.erb"
  variables configuration: {server_name: node[:davical][:server_name] }
  notifies :restart, "service[nginx]"
  action :create
end

if node.platform == "ubuntu"
  link "/etc/nginx/sites-enabled/davical" do
    to "#{conf_dir}/davical"
    action :create
  end
end
