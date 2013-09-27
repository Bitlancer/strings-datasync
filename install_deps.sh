INSTALL="yum -y install"

$INSTALL python python-devel python-setuptools
$INSTALL mysql mysql-devel mysql-server openldap-devel

easy_install pip

pip install --upgrade setuptools
pip install --upgrade distribute

#easy_install -U distribute
#easy_install virtualenv

pip install mysql-python python-ldap nose pep8

$INSTALL java-1.6.0-openjdk

$INSTALL ruby rubygems

gem install ladle --no-ri --no-rdoc
