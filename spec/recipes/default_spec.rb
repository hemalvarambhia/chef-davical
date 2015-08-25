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

      it "installs ufw" do
         expect(chef_run).to install_package "ufw"
      end

      it "sets up the web server" do
        expect(chef_run).to include_recipe "chef-davical::web_server"
      end

      it "sets up the davical database" do
        expect(chef_run).to include_recipe "chef-davical::database"
      end

      it "installs PHP web app-supporting software" do
        expect(chef_run).to include_recipe "chef-davical::php_packages"
      end

      describe "configuring davical" do
        before :each do
          @davical_configuration = "/etc/davical/config.php"
        end

        it "creates the davical config file" do
          expect(chef_run).to create_template(@davical_configuration).with(mode: 0644)
        end

        it "configures the application's connection to the davical database" do
          expect(chef_run).to render_file(@davical_configuration).with_content(/\$c->pg_connect\[\] = \'dbname=davical port=5432 user=davical_app\';/)
        end

        it "configures application's FQDN" do
          expect(chef_run).to render_file(@davical_configuration).with_content(/\$c->domain_name = \'ical.example.com\';/)
        end

        it "configures the system name" do
          expect(chef_run).to render_file(@davical_configuration).with_content(/\$c->system_name = \'Davical Application\';/)
        end

        it "configures the system's email" do
          expect(chef_run).to render_file(@davical_configuration).with_content(/\$c->admin_email = \'admin@email.com\';/)
        end

        it "configures the system time zone" do
          expect(chef_run).to render_file(@davical_configuration).with_content(/\$c->local_tzid = \'Europe\/London\';/)
        end

        it "restarts php5-fpm on any changes" do
          davical_configuration = chef_run.template(@davical_configuration)
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

      it "sets up symbolic links to awls files" do
        expect(chef_run).to run_ruby_block("symbolic_links_to_awl_files")
      end
    end
  end

  context "CentOS" do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: "centos", version: "7.0") do |node|
      node.set[:davical][:server_name] = "ical.example.com"
      node.set[:davical][:system_name] = "Davical Application"
      node.set[:davical][:system_email] = "admin@email.com"
      node.set[:davical][:time_zone] = "Europe/London"
    end.converge(described_recipe) }    

    it "clones the davical and awl sources" do
      expect(chef_run).to sync_git("/usr/share/davical").with(repository: "https://gitlab.com/davical-project/davical.git")
      expect(chef_run).to sync_git("/usr/share/awl").with(repository: "https://gitlab.com/davical-project/awl.git")
    end    
  end
end
