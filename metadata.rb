name              "puppet"
maintainer        "Fletcher Nichol"
maintainer_email  "fnichol@nichol.ca"
license           "Apache 2.0"
description       "Installs and manages a Puppet Master service. No, really."
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.2.0"

supports "ubuntu"

depends "apt"
