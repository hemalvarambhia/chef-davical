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
  end

end
