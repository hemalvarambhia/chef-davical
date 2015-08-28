module ChefDavical
  module Helper
    include Chef::Mixin::ShellOut
    def davical_database_exists?
      list_databases = "sudo su - postgres -c \"psql -c 'select datname from pg_database;'\""
      databases_created_command = shell_out(list_databases, {returns: [0, 2]})

      databases_created_command.stderr.empty? and databases_created_command.stdout.include?("davical")
    end
  end
end

def ubuntu?(version)
  node.platform?("ubuntu") and node.platform_version ==	version
end