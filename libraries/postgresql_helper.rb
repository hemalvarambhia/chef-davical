module Postgresql
  module Helper
    include Chef::Mixin::ShellOut
    def cluster_initialised?(version)
      postgres_dir_exists_command = shell_out("[ -d /etc/postgresql/#{version}/main/ ] && echo initialised", returns: [0, 2])

      postgres_dir_exists_command.stderr.empty? and postgres_dir_exists_command.stdout.strip == "initialised"
    end
  end
end

def version
  case node.platform_version
    when "10.04"
      "8.4"
    when "12.04"
      "9.1"
    when "14.04"
      "9.3"
  end
end

def postgresql_service
  case node.platform_version
    when "10.04"
      "postgresql-8.4"
    when "12.04", "14.04"
      "postgresql"
  end
end