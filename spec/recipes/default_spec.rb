require_relative "../spec_helper.rb"

describe "chef-davical::default" do
  let(:chef_run) { ChefSpec::SoloRunner.new do |node|
    node.set[:davical][:server_name] = "ical.example.com"
    node.set[:davical][:system_name] = "Davical Application"
    node.set[:davical][:system_email] = "admin@email.com"
    node.set[:davical][:time_zone] = "Europe/London"
  end.converge(described_recipe) }

  context "on ubuntu" do
    it "installs DAViCal" do
      expect(chef_run).to install_package "davical"
    end

    it "installs php5-curl" do
      expect(chef_run).to install_package "php5-curl"
    end

    describe "setting up the web server" do
      it "opens up firewall to http connections" do
        expect(chef_run).to allow_firewall_rule("http").with(protocol: :tcp, port: 80)
      end

      it "installs nginx" do
        expect(chef_run).to install_package "nginx"
      end

      it "enables and starts nginx" do
        expect(chef_run).to enable_service("nginx")
        expect(chef_run).to start_service("nginx")
      end

      it "adds the nginx configuration for davical" do
        expect(chef_run).to create_template("/etc/nginx/sites-available/davical")
      end

      describe "configuring nginx" do
        before :each do
          @nginx_configuration = chef_run.template("/etc/nginx/sites-available/davical")
        end

        it "reloads nginx should the configuration change" do
          expect(@nginx_configuration).to notify("service[nginx]").to(:reload)
        end

        it "sets the server name to that defined in the node attributes" do
          expect(@nginx_configuration).to set_server_names_to "ical.example.com"
        end

        it "listens to port 80" do
          expect(@nginx_configuration).to listen_to_port("80")
        end

        it "logs errors to /var/log/nginx/davical_error.log" do
          expect(@nginx_configuration).to log_errors_to("/var/log/nginx/davical_error.log")
        end

        it "logs processed requests to /var/log/nginx/davical_access.log" do
          expect(@nginx_configuration).to log_processed_requests_to("/var/log/nginx/davical_access.log")
        end

        describe "when the request URL matches /" do
          it "forwards requests to URIs like ^/principals/users/(.+)$ to http://ical.example.com/caldav.php/$1" do
            expect(@nginx_configuration).to forward_requests_to("^/principals/users/(.+)$").to("http://ical.example.com/caldav.php/$1").when_request_uri_matches("/")
          end

          it "forwards requests to URIs like /.well-known/(.+)$ to http://ical.example.com/caldav.php/.well-known/$" do
            expect(@nginx_configuration).to forward_requests_to("/.well-known/(.+)$").to("http://ical.example.com/caldav.php/.well-known/$1").when_request_uri_matches("/")
          end
        end

        it "enables the davical site" do
          expect(chef_run).to create_link("/etc/nginx/sites-enabled/davical").with(to: "/etc/nginx/sites-available/davical")
        end
      end
    end

    describe "configuring postgresql" do
      it "creates the host-based authentication file" do
        expect(chef_run).to create_cookbook_file("/etc/postgresql/9.1/main/pg_hba.conf")
      end

      it "trusts davical_app with davical database" do
        postgres_configuration = chef_run.cookbook_file("/etc/postgresql/9.1/main/pg_hba.conf")

        expect(postgres_configuration).to trust_user("davical_app").with_database("davical")
      end

      it "trusts davical_dba with davical database" do
        postgres_configuration = chef_run.cookbook_file("/etc/postgresql/9.1/main/pg_hba.conf")

        expect(postgres_configuration).to trust_user("davical_dba").with_database("davical")
      end

      it "reloads postgresql on any changes" do
        postgres_configuration = chef_run.cookbook_file("/etc/postgresql/9.1/main/pg_hba.conf")

        expect(postgres_configuration).to notify("service[postgresql]").to(:restart).immediately
      end
    end

    it "creates the database" do
      expect(chef_run).to run_execute("create-database.sh").with(cwd: "/usr/share/davical/dba", command: "./create-database.sh", user: "postgres" )
    end

    it "creates the davical config file" do
      expect(chef_run).to create_template("/etc/davical/config.php")
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
  end

end
