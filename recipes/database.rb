Chef::Resource::Execute.send(:include, ChefDavicalHelper)

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
  not_if davical_database_exists?, user: "postgres"
  action :run
end
