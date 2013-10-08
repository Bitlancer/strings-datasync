yum groupinstall "Development Tools"

INSTALL="yum -y install"

$INSTALL python python-devel python-setuptools
$INSTALL mysql mysql-devel mysql-server openldap-devel

# This seemingly simple sequence of commands in fact took a ton of
# work--getting pip and yum to agree isn't easy.  So, edit at your
# peril.

easy_install pip

pip install --upgrade setuptools
pip install --upgrade distribute

pip install mysql-python python-ldap pep8

# For testing only

$INSTALL java-1.6.0-openjdk

$INSTALL ruby rubygems

gem install ladle --no-ri --no-rdoc

pip install mock nose