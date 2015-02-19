if defined?(ChefSpec)
  def set_server_names_to(*server_names)
    ChefSpec::Matchers::NginxServerNameMatcher.new(chef_run, server_names)
  end

  def listen_to_port(port)
    ChefSpec::Matchers::NginxPortListenedToMatcher.new(chef_run, port)
  end
end