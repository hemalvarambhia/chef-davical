if node.platform == "ubuntu"
  package "davical" do
    action :install
  end
else
  package "git" do
    action :install
  end

  git "/usr/share/awl" do
    repository "https://gitlab.com/davical-project/awl.git"
    action :sync
  end
  
  git "/usr/share/davical" do
    repository "https://gitlab.com/davical-project/davical.git"
    action :sync
  end
end

directory "/etc/davical" do
  action :create
end
