require 'spec_helper'


describe "postgresql server" do
  before :each do
    @version = version_of_postgres
  end

  it "is installed" do
    expect(package("postgresql-#{@version}")).to be_installed
  end

  describe service "postgresql" do
    it { should be_enabled }
    it { should be_running }
  end

  describe "configuration" do
    before :each do
      @configuration = file "/etc/postgresql/#{@version}/main/pg_hba.conf"
    end

    it "creates the file" do
      expect(@configuration).to be_file
    end

    it "trusts the davical dba" do
      expect(@configuration.content).to match /local   davical    davical_dba   trust/
    end

    it "trusts the davical application user" do
      expect(@configuration.content).to match /local   davical    davical_app   trust/
    end
  end

  describe command("sudo su - postgres -c \"psql -c 'select datname from pg_database;'\"") do
    its(:stdout) {
      should match /davical/
    }

    its(:exit_status) { should eq 0 }
  end

  private
  def version_of_postgres
    case os[:release]
      when "12.04"
        "9.1"
      when "10.04"
        "8.4"
    end
  end
end
