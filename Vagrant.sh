echo updating package information
apt-add-repository -y ppa:brightbox/ruby-ng >/dev/null 2>&1
apt-get -y update >/dev/null 2>&1
apt-get -y upgrade >/dev/null 2>&1

echo installing development tools
apt-get -y install build-essential >/dev/null 2>&1

echo installing Git
apt-get -y install git >/dev/null 2>&1

echo installing Ruby
apt-get -y install ruby2.0 ruby2.0-dev >/dev/null 2>&1
rm /usr/bin/ruby /usr/bin/gem /usr/bin/irb /usr/bin/rdoc /usr/bin/erb
ln -s /usr/bin/ruby2.0 /usr/bin/ruby
ln -s /usr/bin/gem2.0 /usr/bin/gem
ln -s /usr/bin/irb2.0 /usr/bin/irb
ln -s /usr/bin/rdoc2.0 /usr/bin/rdoc
ln -s /usr/bin/erb2.0 /usr/bin/erb
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo installing Bundler
gem install bundler -N >/dev/null 2>&1
# apt-get -y install bundler >/dev/null 2>&1

echo installing PostGreSQL
apt-get -y install postgresql postgresql-contrib libpq-dev >/dev/null 2>&1
sudo -u postgres createuser --superuser vagrant

echo installing ExecJs runtime
apt-get -y install nodejs >/dev/null 2>&1

echo installing project Gems
cd /vagrant
bundle >/dev/null 2>&1
