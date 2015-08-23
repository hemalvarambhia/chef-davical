require_relative '../spec_helper.rb'

describe "chef-davical::davical" do
  context "Installing on Ubuntu" do
    
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: "ubuntu", version: "14.04") do |node|

    end.converge(described_recipe)}
  
    it "installs davical deb package" do
      expect(chef_run).to install_package "davical"
    end
  end

  context "Installing on CentOS" do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: "centos", version: "7.0") do |node|
                       
                     end.converge(described_recipe) }

    it "installs git" do
      expect(chef_run).to install_package "git"
    end
    
    it "clones davical and awl source codes" do
      expect(chef_run).to sync_git("/usr/share/davical").with(repository: "https://gitlab.com/davical-project/davical.git")
      expect(chef_run).to sync_git("/usr/share/awl").with(repository: "https://gitlab.com/davical-project/awl.git")
    end
    
    it "creates the /etc/davical config directory" do
      expect(chef_run).to create_directory "/etc/davical"
    end
  end
end
