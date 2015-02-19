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
end