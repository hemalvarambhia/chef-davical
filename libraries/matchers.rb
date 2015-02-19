if defined?(ChefSpec)
  def set_server_names_to(*server_names)
    ChefSpec::Matchers::NginxServerNameMatcher.new(chef_run, server_names)
  end

  def listen_to_port(port)
    ChefSpec::Matchers::NginxPortListenedToMatcher.new(chef_run, port)
  end

  def log_errors_to(path_to_log_file)
    ChefSpec::Matchers::NginxErrorLogMatcher.new(chef_run, path_to_log_file)
  end
end