require 'serverspec'

set :backend, :exec

describe package("davical") do
  it { should be_installed }
end