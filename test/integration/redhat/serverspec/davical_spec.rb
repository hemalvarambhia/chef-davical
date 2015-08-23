require 'spec_helper'
describe file("/usr/share/awl") do
  it { should be_directory }
end

describe file("/usr/share/davical") do
  it { should be_directory }
end

describe file("/etc/davical") do
  it { should be_directory }
end


