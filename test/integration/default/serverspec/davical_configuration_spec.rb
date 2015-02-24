require 'spec_helper'

describe file("/etc/davical/config.php") do
  it { should be_file }
  its(:content) {
    expected = ["$c->domain_name = 'ical.example.com';", "$c->admin_email = 'admin@email.com';", "$c->local_tzid = 'Europe/London';", "$c->system_name = 'Application';", "$c->pg_connect[] = 'dbname=davical port=5432 user=davical_app';"]
    should match Regexp.escape(expected.join("\n"))
  }
end