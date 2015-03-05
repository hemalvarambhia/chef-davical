require 'spec_helper'

describe package "php5-curl" do
  it { should be_installed }
end

if os[:release] == "10.04"
  describe package "python-software-properties" do
    it { should be_installed }
  end
end

describe package "php5-fpm" do
  it { should be_installed }
end

describe service "php5-fpm" do
  it { should be_running }
end
