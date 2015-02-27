module ChefDavical
  module Helper
    include Chef::Mixin::ShellOut
    def davical_database_exists?
      databases_created_command = shell_out("sudo su - postgres -c \"psql -c 'select datname from pg_database;'\"", {returns: [0, 2]})

      databases_created_command.stderr.empty? and databases_created_command.stdout.include?("davical")
    end
  end
end

