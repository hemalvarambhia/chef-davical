module ChefDavicalHelper
  include Chef::Mixin::ShellOut
  def davical_database_exists?
    databases = shell_out("psql -c 'select datname from pg_database;'", returns: [0, 2])
    davical = Regexp.escape "Davical"

    databases.stderr.empty? and databases=~davical
  end
end