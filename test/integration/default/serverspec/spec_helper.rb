require 'serverspec'

set :backend, :exec
set :path, '/bin:/usr/local/bin:$PATH'

RSpec::Matchers.define :set_server_names_to do |server_names|
  match do |content|
    escaped_server_names = server_names.collect{|server_name| Regexp.escape(server_name)}

    expected_content = /server \{[^}]+server_name #{escaped_server_names.join(" ")};/m

    content=~expected_content
  end
end

RSpec::Matchers.define :listen_to_port do |port_number|
  match do |content|
    expected_content = /server \{[^}]+listen #{port_number};/m

    content=~expected_content
  end
end

RSpec::Matchers.define :log_errors_to do |path_to_error_log|
  match do |content|
    expected_content = /server \{[^}]+error_log #{Regexp.escape(path_to_error_log)};/

    content=~expected_content
  end
end