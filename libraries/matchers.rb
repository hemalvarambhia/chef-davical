if defined?(ChefSpec)
  def set_server_names_to(*server_names)
    ChefSpec::Matchers::NginxServerNameMatcher.new(chef_run, server_names)
  end
end