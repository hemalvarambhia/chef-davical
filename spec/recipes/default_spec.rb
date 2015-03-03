require_relative "../spec_helper.rb"

describe "chef-davical::default" do
  let(:chef_run) { ChefSpec::SoloRunner.new do |node|
    node.set[:davical][:server_name] = "ical.example.com"
    node.set[:davical][:system_name] = "Davical Application"
    node.set[:davical][:system_email] = "admin@email.com"
    node.set[:davical][:time_zone] = "Europe/London"
  end.converge(described_recipe) }

  context "on ubuntu" do
    context "all versions" do
      it "installs DAViCal" do
        expect(chef_run).to install_package "davical"
      end

      it "installs php5-curl" do
        expect(chef_run).to install_package "php5-curl"
      end

      it "sets up the web server" do
        expect(chef_run).to include_recipe "chef-davical::web_server"
      end

      it "sets up the davical database" do
        expect(chef_run).to include_recipe "chef-davical::database"
      end

      describe "configuring davical" do
        it "creates the davical config file" do
          expect(chef_run).to create_template("/etc/davical/config.php").with(mode: 0644)
        end

        it "configures the application's connection to the davical database" do
          expect(chef_run).to render_file("/etc/davical/config.php").with_content(/\$c->pg_connect\[\] = \'dbname=davical port=5432 user=davical_app\';/)
        end

        it "configures application's FQDN" do
          expect(chef_run).to render_file("/etc/davical/config.php").with_content(/\$c->domain_name = \'ical.example.com\';/)
        end

        it "configures the system name" do
          expect(chef_run).to render_file("/etc/davical/config.php").with_content(/\$c->system_name = \'Davical Application\';/)
        end

        it "configures the system's email" do
          expect(chef_run).to render_file("/etc/davical/config.php").with_content(/\$c->admin_email = \'admin@email.com\';/)
        end

        it "configures the system time zone" do
          expect(chef_run).to render_file("/etc/davical/config.php").with_content(/\$c->local_tzid = \'Europe\/London\';/)
        end

        it "restarts php5-fpm on any changes" do
          davical_configuration = chef_run.template("/etc/davical/config.php")
          expect(davical_configuration).to notify("service[php5-fpm]").to(:restart)
        end
      end
    end

    context "10.04" do
      let(:chef_run) { ChefSpec::SoloRunner.new(platform: "ubuntu", version: "10.04") do |node|
        node.set[:davical][:server_name] = "ical.example.com"
        node.set[:davical][:system_name] = "Davical Application"
        node.set[:davical][:system_email] = "admin@email.com"
        node.set[:davical][:time_zone] = "Europe/London"
      end.converge(described_recipe) }

      it "adds the brianmercer PHP repo" do
        expect(chef_run).to add_apt_repository("brianmercer-php").with(uri: "http://ppa.launchpad.net/brianmercer/php/ubuntu", keyserver: "keyserver.ubuntu.com", key: "8D0DC64F")
      end

      it "installs php5-fpm" do
        expect(chef_run).to install_package "php5-fpm"
      end

      it "starts php-fpm" do
        expect(chef_run).to start_service "php5-fpm"
      end
    end
  end
end
