require 'spec_helper'

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