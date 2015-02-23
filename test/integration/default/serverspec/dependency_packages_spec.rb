require 'spec_helper'

describe package("davical") do
  it { should be_installed }
end

describe package("libawl-php") do
  it { should be_installed }
end

describe package("php5-curl") do
  it { should be_installed }
end
