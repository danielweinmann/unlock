#!/usr/bin/env bash
set -o pipefail
set -e
set -x

if [ ! -f '/etc/apt/sources.list.d/brightbox-ruby-ng-trusty.list' ]; then
  apt-add-repository -y ppa:brightbox/ruby-ng
fi

apt-get -y update
apt-get -y upgrade

update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

apt-get -y install build-essential git ruby2.0 ruby2.0-dev postgresql postgresql-contrib libpq-dev nodejs

rm /usr/bin/ruby /usr/bin/gem /usr/bin/irb /usr/bin/rdoc /usr/bin/erb
ln -s /usr/bin/ruby2.0 /usr/bin/ruby
ln -s /usr/bin/gem2.0 /usr/bin/gem
ln -s /usr/bin/irb2.0 /usr/bin/irb
ln -s /usr/bin/rdoc2.0 /usr/bin/rdoc
ln -s /usr/bin/erb2.0 /usr/bin/erb

gem list bundler | grep -q bundler
if [ $? -ne 0 ]; then
  gem install bundler -N
fi

if [ $(sudo -u postgres psql -tc "SELECT count(*) FROM pg_user WHERE usename='vagrant'") == 0 ]; then
  sudo -u postgres psql -c "CREATE ROLE vagrant WITH PASSWORD 'vagrant' LOGIN SUPERUSER"
fi

if [ $(sudo -u postgres psql -tc "SELECT count(*) FROM pg_database WHERE datname='unlock_development'") == 0 ]; then
  sudo -u postgres createdb -O vagrant unlock_development
fi

if [ $(sudo -u postgres psql -tc "SELECT count(*) FROM pg_database WHERE datname='unlock_test'") == 0 ]; then
  sudo -u postgres createdb -O vagrant unlock_test
fi

if [ $(sudo -u postgres psql -tc "SELECT count(*) FROM pg_database WHERE datname='unlock_production'") == 0 ]; then
  sudo -u postgres createdb -O vagrant unlock_production
fi

pushd /vagrant
  bundle install
  cat <<EOF > config/database.yml
default: &default
  adapter: postgresql
  pool: 5
  timeout: 5000
  username: vagrant
  password: vagrant
  host: localhost
  port: 5432

development:
  <<: *default
  database: unlock_development

test:
  <<: *default
  database: unlock_test

production:
  <<: *default
  database: unlock_production
EOF
  rake db:migrate
  rake db:setup
popd
