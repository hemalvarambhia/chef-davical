require 'spec_helper'

describe "postgresql server" do
  describe package "postgresql-server" do
    it { should be_installed }
  end

  describe service("postgresql") do
    it { should be_running }
  end
end
