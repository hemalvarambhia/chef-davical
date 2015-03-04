include_recipe "firewall::default"

firewall_rule "http" do
  protocol :tcp
  port 80
  action :allow
end

if node.platform_version == "10.04"
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

template "/etc/nginx/sites-available/davical" do
  source "nginx_configuration.erb"
  variables configuration: {server_name: node[:davical][:server_name] }
  notifies :restart, "service[nginx]"
  action :create
end

link "/etc/nginx/sites-enabled/davical" do
  to "/etc/nginx/sites-available/davical"
  action :create
end