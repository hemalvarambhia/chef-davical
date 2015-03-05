name             'chef-davical'
maintainer       'Hemal N Varambhia'
maintainer_email 'h.n.varambhia@gmail.com'
license          'All rights reserved'
description      'Installs/Configures davical'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.4.1'

supports "ubuntu"

depends "apt"
depends "firewall"
