require 'spec_helper'

describe "postgresql server" do
  describe package "postgresql-server" do
    it { should be_installed }
  end

  describe service("postgresql") do
    it { should be_running }
  end
end

describe command("sudo su - postgres -c \"psql -c 'select datname from pg_database;'\"") do
    its(:stdout) { should match /davical/ }

    its(:exit_status) { should eq 0 }
end