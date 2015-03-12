require 'spec_helper'

describe "postgresql server" do
  version = case os[:release]
              when "14.04"
                "9.3"
              when "12.04"
                "9.1"
              when "10.04"
                "8.4"
            end

  describe package "postgresql-#{version}" do
    it { should be_installed }
  end

  describe service "postgresql" do
    it { should be_enabled }
    it { should be_running }
  end

  describe "configuration" do
    describe file "/etc/postgresql/#{version}/main/pg_hba.conf" do
      it { should be_file }
      its(:content) { should match /local   davical    davical_dba   trust/ }
      its(:content) { should match /local   davical    davical_app   trust/ }
    end
  end

  describe command("sudo su - postgres -c \"psql -c 'select datname from pg_database;'\"") do
    its(:stdout) { should match /davical/ }

    its(:exit_status) { should eq 0 }
  end
end
