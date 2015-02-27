require_relative "../spec_helper.rb"

describe "chef-davical::database" do
  let(:chef_run) { ChefSpec::SoloRunner.new do |node|
    node.set[:davical][:server_name] = "ical.example.com"
    node.set[:davical][:system_name] = "Davical Application"
    node.set[:davical][:system_email] = "admin@email.com"
    node.set[:davical][:time_zone] = "Europe/London"
  end.converge(described_recipe) }

  context "on ubuntu" do
    context "version 12.04" do
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
  end
end