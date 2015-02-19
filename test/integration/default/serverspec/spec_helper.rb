require 'serverspec'

set :backend, :exec
set :path, '/bin:/usr/local/bin:$PATH'

RSpec::Matchers.define :set_server_names_to do |server_names|
  match do |content|
    escaped_server_names = server_names.collect{|server_name| Regexp.escape(server_name)}

    expected_content = /server \{[^}]+server_name #{escaped_server_names.join(" ")};/m

    content=~expected_content
  end

  failure_message do |actual|
    failure_message = "Expected Nginx accept requests to #{server_names.join(", ")}\n"
    failure_message << "Instead, got:\n"
    failure_message << actual

    failure_message
  end
end

RSpec::Matchers.define :listen_to_port do |port_number|
  match do |content|
    expected_content = /server \{[^}]+listen #{port_number};/m

    content=~expected_content
  end

  failure_message do |actual|
    failure_message = "Expected Nginx to listen to port #{port_number}\n"
    failure_message << "Instead, got:\n"
    failure_message << actual

    failure_message
  end
end

RSpec::Matchers.define :log_errors_to do |path_to_error_log|
  match do |content|
    expected_content = /server \{[^}]+error_log #{Regexp.escape(path_to_error_log)};/

    content=~expected_content
  end

  failure_message do |actual|
    failure_message = "Expected Nginx to log errors to #{path_to_error_log}\n"
    failure_message << "Instead, got:\n"
    failure_message << actual

    failure_message
  end
end

RSpec::Matchers.define :log_processed_requests_to do |path_to_access_log|
  match do |content|
    expected_content = /server \{[^}]+access_log #{Regexp.escape(path_to_access_log)};/

    content=~expected_content
  end

  failure_message do |actual|
    failure_message = "Expected Nginx to log processed requests to #{path_to_access_log}\n"
    failure_message << "Instead, got:\n"
    failure_message << actual

    failure_message
  end
end

RSpec::Matchers.define :redirect_requests_to do |original_uri|
  match do |content|
    escaped_original_uri = Regexp.escape original_uri
    expected = /location #{@request_uri} \{[^}]+rewrite #{escaped_original_uri}\s+#{@new_uri} break;/m

    content=~expected
  end

  chain :to do |new_uri|
    @new_uri = Regexp.escape new_uri
  end

  chain :when_request_uri_matches do |request_uri|
    @request_uri = Regexp.escape request_uri
  end

  failure_message do |actual|
    failure_message = "Expected Nginx to redirect requests like #{original_uri}\n"
    failure_message << " to #{@new_uri} when the request URI matches #{@request_uri}\n"
    failure_message << "Instead, got:\n"
    failure_message << actual

    failure_message
  end
end