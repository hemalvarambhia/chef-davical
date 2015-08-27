Chef::Resource::Execute.send(:include, ChefDavical::Helper)
Chef::Resource::Execute.send(:include, Postgresql::Helper)

package postgresql_server do
  action :install
end

%w{perl-YAML perl-DBD-Pg}.each do |library|
  package library do
    action :install
  end
end if node.platform == "centos"

service postgresql_service do
  action :nothing
end

execute("initialise-database-cluster") do
  command "pg_createcluster --locale en_GB.UTF-8 #{version} main"
  not_if { cluster_initialised? }
  action :run
end if node.platform_version == "10.04"

execute "initialize-database-cluster" do
  command "postgresql-setup initdb"
  not_if { cluster_initialised? }
  action :run
end if node.platform == "centos"

cookbook_file "#{database_conf_dir}/pg_hba.conf" do
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :restart, "service[#{postgresql_service}]", :immediately
  action :create
end

[
    "sed -i \"s/'PlPgSQL'/'plpgsql'/\" ./*sql ./patches/*sql",
    "sed -i \"s/'SQL'/'sql'/\" ./*sql ./patches/*sql"
].each do |command|
  execute command do
    cwd "/usr/share/davical/dba"
    action :run
  end
end if node.platform_version == "14.04"

execute "create-database.sh" do
  command "./create-database.sh"
  user "postgres"
  cwd "/usr/share/davical/dba"
  not_if { davical_database_exists? }
  action :run
end
