postgresql_dir = case node[:platform_version].to_f
                   when 12.04
                     "/etc/postgresql/9.1/main"
                   when 14.04
                     "/etc/postgresql/9.3/main"
                 end

service "postgresql" do
  action :start
end

cookbook_file "#{postgresql_dir}/pg_hba.conf" do
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
