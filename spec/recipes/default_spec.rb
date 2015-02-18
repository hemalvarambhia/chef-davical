require_relative "../spec_helper.rb"

describe "chef-davical::default" do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

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
    end
  end

end
