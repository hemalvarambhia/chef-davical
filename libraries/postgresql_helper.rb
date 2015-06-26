module Postgresql
  module Helper
    include Chef::Mixin::ShellOut
    def cluster_initialised?
      postgres_dir_exists_command = shell_out("[ -d #{database_conf_dir} ] && echo initialised", returns: [0, 2])

      postgres_dir_exists_command.stderr.empty? and postgres_dir_exists_command.stdout.strip == "initialised"
    end
  end
end

def postgresql_server
  if node.platform == "ubuntu"
    "postgresql-#{version}"
  else
    "postgresql-server"
  end
end

def database_conf_dir
  if node.platform == "ubuntu"
    "/etc/postgresql/#{version}/main"
  else
    "/var/lib/pgsql/data"
  end
end

def version
  if node.platform == "ubuntu"
    case node.platform_version
      when "10.04"
        "8.4"
      when "12.04"
        "9.1"
      when "14.04"
        "9.3"
    end
  end
end

def postgresql_service
  if node.platform == "ubuntu"
    case node.platform_version
      when "10.04"
        "postgresql-8.4"
      when "12.04", "14.04"
        "postgresql"
    end
  else
    "postgresql"
  end
end
