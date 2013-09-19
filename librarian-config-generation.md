ou=config,ou=librarian,...

dn: cn=ntp,ou=puppetlabs,ou=librarian,...
description: {"name": "puppetlabs/ntp","type":"forge","url":"http://forge.puppetlabs.com","reference":null,"path":null}

dn: cn=mysql,ou=puppetlabs,ou=librarian,...
description: {"name": "puppetlabs/mysql","type":"forge","url":"http://forge.puppetlabs.com","reference":"0.0.3","path":null}

dn: cn=apache,ou=bitlancer,ou=librarian,...
description: {"name": "bitlancer/apache","type":"git","url":"git://github.com/bitlancer/bitlancer-apache.git","reference":null,"path":null}

dn: cn=mysql,ou=bitlancer,ou=librarian,...
description: {"name": "bitlancer/mysql","type":"git","url":"git://github.com/bitlancer/bitlancer-apache.git","reference":"1.1","path":"feature/great-new-feature"}

OR

ou=librarian,...

dn: cn=config,ou=librarian,...
description: [{"name": "puppetlabs/ntp","type":"forge","url":"http://forge.puppetlabs.com","reference":null,"path":null},{"name": "puppetlabs/mysql","type":"forge","url":"http://forge.puppetlabs.com","reference":"0.0.3","path":null},{"name": "bitlancer/apache","type":"git","url":"git://github.com/bitlancer/bitlancer-apache.git","reference":null,"path":null},{"name": "bitlancer/mysql","type":"git","url":"git://github.com/bitlancer/bitlancer-apache.git","reference":"1.1","path":"feature/great-new-feature"}]


** Generate

mod "puppetlabs/ntp"
  :forge => "http://forge.puppetlabs.com"

mod "puppetlabs/mysql"
  :forge => "http://forge.puppetlabs.com"
  :ref => "0.0.3"

mod "bitlancer/apache"
  :git => "git://github.com/bitlancer/bitlancer-apache.git"

mod "bitlancer/mysql"
  :git => "git://github.com/bitlancer/bitlancer-apache.git"
  :ref => "1.1
  :path => "feature/great-new-feature"
