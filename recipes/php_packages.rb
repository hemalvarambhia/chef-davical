package "php5-curl" do
  action :install
end

if node.platform_version == "10.04"
  package "python-software-properties" do
    action :install
  end

  apt_repository "brianmercer-php" do
    uri "http://ppa.launchpad.net/brianmercer/php/ubuntu"
    distribution node[:lsb][:codename]
    components ["main"]
    keyserver "keyserver.ubuntu.com"
    key "8D0DC64F"
    action :add
  end
end

package "php5-fpm" do
  action :install
end

service "php5-fpm" do
  action :start
end