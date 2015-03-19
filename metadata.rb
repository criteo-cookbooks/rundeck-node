name             'rundeck-node'
maintainer       'Robert Veznaver'
maintainer_email 'r.veznaver@criteo.com'
license          'Apache License 2.0'
description      'Installs a rundeck node and configure as needed'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.2'

depends          'sudo'
depends          'openssl'
depends          'winrm-config'

suggests         'rundeck-server'
suggests         'rundeck-bridge'
