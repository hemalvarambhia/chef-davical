module Postgresql
  module Helper
    include Chef::Mixin::ShellOut
    def cluster_initialised?(version)
      postgres_dir_exists_command = shell_out("[ -d /etc/postgresql/#{version}/main/ ] && echo true", returns: [0, 2])

      postgres_dir_exists_command.stderr.empty? and postgres_dir_exists_command.stdout.strip == "true"
    end
  end
end