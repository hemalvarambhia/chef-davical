require_relative "../spec_helper.rb"

describe "chef-davical::database" do
  context "on ubuntu" do
    context "10.04" do
      let(:chef_run) { ChefSpec::SoloRunner.new(platform: "ubuntu", version: "10.04") do |node|
        node.set[:davical][:server_name] = "ical.example.com"
        node.set[:davical][:system_name] = "Davical Application"
        node.set[:davical][:system_email] = "admin@email.com"
        node.set[:davical][:time_zone] = "Europe/London"
      end.converge(described_recipe) }

      it "installs postgresql server 8.4" do
        expect(chef_run).to install_package("postgresql-8.4")
      end

      it "initialises the database cluster" do
        expect(chef_run).to run_execute("initialise-database-cluster").with(command: "pg_createcluster --locale en_GB.UTF-8 8.4 main")
      end

      context "when cluster is already initialised" do
        it "does not initialise it again" do
          Chef::Resource::Execute.any_instance.stub(:cluster_initialised?).and_return(true)

          expect(chef_run).to_not run_execute("initialise-database-cluster").with(command: "pg_createcluster --locale en_GB.UTF-8 8.4 main")
        end
      end
    end

    context "12.04" do
      let(:chef_run) { ChefSpec::SoloRunner.new(platform: "ubuntu", version: "12.04") do |node|
        node.set[:davical][:server_name] = "ical.example.com"
        node.set[:davical][:system_name] = "Davical Application"
        node.set[:davical][:system_email] = "admin@email.com"
        node.set[:davical][:time_zone] = "Europe/London"
      end.converge(described_recipe) }

      it "installs postgresql server 9.1" do
        expect(chef_run).to install_package("postgresql-9.1")
      end

      it "does not initialise the database cluster" do
        expect(chef_run).to_not run_execute("initialise-database-cluster").with(command: "pg_createcluster --locale en_GB.UTF-8 9.1 main")
      end

      describe "configuring postgresql" do
        it "creates the host-based authentication file" do
          expect(chef_run).to create_cookbook_file("/etc/postgresql/9.1/main/pg_hba.conf")
        end

        it "trusts davical_app with davical database" do
          postgres_configuration = chef_run.cookbook_file("/etc/postgresql/9.1/main/pg_hba.conf")

          expect(postgres_configuration).to trust_user("davical_app").with_database("davical")
        end

        it "trusts davical_dba with davical database" do
          postgres_configuration = chef_run.cookbook_file("/etc/postgresql/9.1/main/pg_hba.conf")

          expect(postgres_configuration).to trust_user("davical_dba").with_database("davical")
        end

        it "reloads postgresql on any changes" do
          postgres_configuration = chef_run.cookbook_file("/etc/postgresql/9.1/main/pg_hba.conf")

          expect(postgres_configuration).to notify("service[postgresql]").to(:restart).immediately
        end
      end

      it "creates the database" do
        expect(chef_run).to run_execute("create-database.sh").with(cwd: "/usr/share/davical/dba", command: "./create-database.sh", user: "postgres" )
      end
    end

    context "14.04" do
      let(:chef_run) { ChefSpec::SoloRunner.new(platform: "ubuntu", version: "14.04") do |node|
        node.set[:davical][:server_name] = "ical.example.com"
        node.set[:davical][:system_name] = "Davical Application"
        node.set[:davical][:system_email] = "admin@email.com"
        node.set[:davical][:time_zone] = "Europe/London"
      end.converge(described_recipe) }

      it "installs postgresql server 9.3" do
        expect(chef_run).to install_package("postgresql-9.3")
      end

      describe "configuration" do
        it "creates the host-based authentication file" do
          expect(chef_run).to create_cookbook_file("/etc/postgresql/9.3/main/pg_hba.conf")
        end
      end
    end
  end

  context "CentOS" do
      let(:chef_run) { ChefSpec::SoloRunner.new(platform: "centos", version: "7.0") do |node|
        node.set[:davical][:server_name] = "ical.example.com"
        node.set[:davical][:system_name] = "Davical Application"
        node.set[:davical][:system_email] = "admin@email.com"
        node.set[:davical][:time_zone] = "Europe/London"
      end.converge(described_recipe) }

    it "installs postgresql-server" do
      expect(chef_run).to install_package "postgresql-server"
    end
  end
end
