require_relative '../spec_helper.rb'

describe "chef-davical::davical" do
  context "Ubuntu" do
    
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: "ubuntu", version: "14.04") do |node|

    end.converge(described_recipe)}
  

    it "installs davical"
  end

  context "CentOS" do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: "centos", version: "7.0") do |node|
                       
                     end.converge(describe_recipe) }

    it "install git"
    it "clones davical and awl source codes"
    it "creates the /etc/davical config directory"
  end
end
