Chef::Resource::Execute.send(:include, ChefDavical::Helper)
Chef::Resource::Execute.send(:include, Postgresql::Helper)


version = case node.platform_version
            when "10.04"
              "8.4"
            when "12.04"
              "9.1"
          end

postgresql_service = case node.platform_version
                 when "10.04"
                   "postgresql-8.4"
                 when "12.04"
                   "postgresql"
               end

package "postgresql-#{version}" do
  action :install
end

service postgresql_service do
  action :nothing
end

execute("initialise-database-cluster") do
  command "pg_createcluster --locale en_GB.UTF-8 #{version} main"
  not_if { cluster_initialised?(version) }
  action :run
end if node.platform_version == "10.04"

cookbook_file "/etc/postgresql/#{version}/main/pg_hba.conf" do
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :restart, "service[#{postgresql_service}]", :immediately
  action :create
end

execute "create-database.sh" do
  command "./create-database.sh"
  user "postgres"
  cwd "/usr/share/davical/dba"
  not_if { davical_database_exists? }
  action :run
end
