require 'spec_helper'

describe package("davical") do
  it { should be_installed }
end

describe package("libawl-php") do
  it { should be_installed }
end

describe package("php5-curl") do
  it { should be_installed }
end

describe port("80") do
  it { should be_listening }
end

describe package("nginx") do
  it { should be_installed }
end

describe service("nginx") do
  it { should be_enabled }
  it { should be_running }
end

describe file("/etc/nginx/sites-available/davical") do
  it { should be_file }
  its(:content) {
    should set_server_names_to(["ical.example.com"])
  }

  its(:content) {
    should listen_to_port(80)
  }

  its(:content) {
    should log_errors_to "/var/log/nginx/davical_error.log"
  }

  its(:content) {
    should log_processed_requests_to "/var/log/nginx/davical_access.log"
  }

  its(:content) {
    should redirect_requests_to("^/principals/users/(.+)$").to("http://ical.example.com/caldav.php/$1").when_request_uri_matches("/")
  }

  its(:content) {
    should redirect_requests_to("/.well-known/(.+)$").to("http://ical.example.com/caldav.php/.well-known/$1").when_request_uri_matches("/")
  }
end

describe package "postgresql-9.1" do
  it { should be_installed }
end

describe service "postgres" do
  it { should be_enabled }
  it { should be_running }
end

describe file("/etc/postgresql/9.1/main/pg_hba.conf") do
  it { should be_file }
  its(:content) {
    should match /local   davical    davical_app   trust/
  }

  its(:content) {
    should match /local   davical    davical_dba   trust/
  }
end