if node.platform == "ubuntu"
  package "php5-curl" do
    action :install
  end
else
  package "php-common" do
    action :install
  end

  package "php-curl" do
    action :install
  end
end

if ubuntu?("10.04")
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

php_fpm = if node.platform == "ubuntu"
            "php5-fpm"
          else
            "php-fpm"
          end

package php_fpm do
  action :install
end

service php_fpm do
  action :start
end
