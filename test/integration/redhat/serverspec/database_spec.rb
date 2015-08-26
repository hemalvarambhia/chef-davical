require 'spec_helper'

describe "postgresql server" do
  describe package "postgresql-server" do
    it { should be_installed }
  end

  describe service("postgresql") do
    it { should be_running }
  end

  context "configuration" do
    describe file "/var/lib/pgsql/data/pg_hba.conf" do
      it { should be_file }
      its(:content) { should match /local   davical    davical_dba   trust/ }
      its(:content) { should match /local   davical    davical_app   trust/ }
    end
  end
end

describe command("sudo su - postgres -c \"psql -c 'select datname from pg_database;'\"") do
    its(:stdout) { should match /davical/ }

    its(:exit_status) { should eq 0 }
end