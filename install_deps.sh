INSTALL="yum -y install"

$INSTALL python python-devel python-setuptools
$INSTALL mysql mysql-devel mysql-server openldap-devel

easy_install -U distribute
#easy_install virtualenv

easy_install mysql-python python-ldap nose pep8
