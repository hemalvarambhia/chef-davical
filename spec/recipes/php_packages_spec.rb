require_relative '../spec_helper'

describe "chef-davical::php_packages" do
  describe "on ubuntu" do
    context "all versions" do
      let(:chef_run) { ChefSpec::SoloRunner.new do |node|
        node.set[:davical][:server_name] = "ical.example.com"
        node.set[:davical][:system_name] = "Davical Application"
        node.set[:davical][:system_email] = "admin@email.com"
        node.set[:davical][:time_zone] = "Europe/London"
      end.converge(described_recipe) }

      it "installs php5-curl" do
        expect(chef_run).to install_package "php5-curl"
      end

      it "installs php5-fpm" do
        expect(chef_run).to install_package "php5-fpm"
      end

      it "starts php-fpm" do
        expect(chef_run).to start_service "php5-fpm"
      end
    end

    context "10.04" do
      let(:chef_run) { ChefSpec::SoloRunner.new(platform: "ubuntu", version: "10.04") do |node|
        node.set[:davical][:server_name] = "ical.example.com"
        node.set[:davical][:system_name] = "Davical Application"
        node.set[:davical][:system_email] = "admin@email.com"
        node.set[:davical][:time_zone] = "Europe/London"
      end.converge(described_recipe) }

      it "installs python-software-properties" do
        expect(chef_run).to install_package "python-software-properties"
      end

      it "adds the brianmercer PHP repo" do
        expect(chef_run).to add_apt_repository("brianmercer-php").with(uri: "http://ppa.launchpad.net/brianmercer/php/ubuntu", keyserver: "keyserver.ubuntu.com", key: "8D0DC64F")
      end
    end
  end
end