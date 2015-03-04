require 'spec_helper'

describe file("/etc/davical/config.php") do
  it { should be_file }
  its(:content) {
    expected = [
        "$c->domain_name = 'ical.example.com';",
        "$c->admin_email = 'admin@email.com';",
        "$c->local_tzid = 'Europe/London';",
        "$c->system_name = 'Application';",
        "$c->pg_connect[] = 'dbname=davical port=5432 user=davical_app';"
    ]
    should match Regexp.escape(expected.join("\n"))
  }

  it { should be_mode 644 }
end

if os[:release] == "10.04"
  %w{AuthPlugin.php AuthPlugins.php AWLUtilities.php classBrowser.php DataEntry.php DataUpdate.php
EMail.php iCalendar.php MenuSet.php PgQuery.php Session.php Translation.php User.php Validation.php
vEvent.php XMLDocument.php XMLElement.php}.each do |file|
    describe file "/usr/share/davical/inc/#{file}" do
      it {should be_linked_to "/usr/share/awl/inc/#{file}"}
    end
  end
end
