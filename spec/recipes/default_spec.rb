require_relative "../spec_helper.rb"

describe "chef-davical::default" do
  let(:chef_run) { ChefSpec::SoloRunner.new do |node|
    node.set[:davical][:server_name] = "ical.example.com"
  end.converge(described_recipe) }

  context "on ubuntu" do
    it "installs DAViCal" do
      expect(chef_run).to install_package "davical"
    end

    it "installs php5-curl" do
      expect(chef_run).to install_package "php5-curl"
    end

    describe "setting up the web server" do
      it "installs nginx" do
        expect(chef_run).to install_package "nginx"
      end

      it "enables and starts nginx" do
        expect(chef_run).to enable_service("nginx")
        expect(chef_run).to start_service("nginx")
      end

      it "adds the nginx configuration for davical" do
        expect(chef_run).to create_template("/etc/nginx/sites-available/davical")
      end

      describe "configuring nginx" do
        it "sets the server name to that defined in the node attributes" do
          nginx_configuration = chef_run.template("/etc/nginx/sites-available/davical")

          expect(nginx_configuration).to set_server_names_to "ical.example.com"
        end

        it "listens to port 80" do
          nginx_configuration = chef_run.template("/etc/nginx/sites-available/davical")

          expect(nginx_configuration).to listen_to_port("80")
        end
      end
    end
  end

end
