yum groupinstall "Development Tools"

INSTALL="yum -y install"

$INSTALL python python-devel python-setuptools

cat > /etc/yum.repos.d/mariadb.repo <<'END'
# MariaDB 10.0 CentOS repository list - created 2014-05-02 14:02 UTC
# http://mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.0/centos6-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
END

$INSTALL MariaDB-client MariaDB-server MariaDB-devel openldap-devel

exit

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
