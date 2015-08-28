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

%w{AuthPlugin.php AuthPlugins.php AWLUtilities.php classBrowser.php DataEntry.php DataUpdate.php
EMail.php iCalendar.php MenuSet.php PgQuery.php Session.php Translation.php User.php Validation.php 
XMLDocument.php XMLElement.php}.each do |file|
  describe file "/usr/share/davical/inc/#{file}" do
    it {should be_linked_to "/usr/share/awl/inc/#{file}"}
  end
end

