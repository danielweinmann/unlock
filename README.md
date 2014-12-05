# Unlock [![Build Status](https://secure.travis-ci.org/danielweinmann/unlock.png?branch=master)](https://travis-ci.org/danielweinmann/unlock) [![Code Climate](https://codeclimate.com/github/danielweinmann/unlock/badges/gpa.svg)](https://codeclimate.com/github/danielweinmann/unlock)

Unlock people's pontential through recurring crowdfunding.

## Installing

There are two ways to install and run Unlock for development:

### Locally

First, make sure your system has the following dependencies:

* Ruby 2.0+ 
* PostgreSQL 9.3+ (you'll need the postgresql contrib modules as well)

Then, simply clone the repository:

```
git clone git@github.com:danielweinmann/unlock.git
```

And install all the gem dependencies: 

```
cd unlock
bundle install
```

Copy `config/database.sample.yml` into `config/database.yml`,
adjusting any options to your database configuration. To create the
schema and run the migrations:

```
rake db:migrate
rake db:setup
```

At this point, you should have a green build:

```
rake
```

...and you're ready to go! :)

### Using Vagrant

Before installing, make sure you have recent versions of
[Git](http://www.git-scm.com/), [Vagrant](https://www.vagrantup.com/)
and [VirtualBox](https://www.virtualbox.org/) installed on your
development machine.

Then, simply clone the repository:

```
git clone git@github.com:danielweinmann/unlock.git
```

And create a Vagrant machine from the root of the project:

```
cd unlock
vagrant up
```

This will download and install all the required dependencies, and
set up the database for you.  To make sure everything worked well,
try running the tests:

```
vagrant ssh -c 'cd /vagrant && rake'
```

To run the application in development mode:

```
vagrant ssh -c 'cd /vagrant && rails server'
```

## Payment gateways

Every initiative on Unlock can add and configure multiple payment
gateways, which are separate gems which follow the
[UnlockGateway](https://github.com/danielweinmann/unlock_gateway)
pattern.

### Available gateways

* [unlock_moip](https://github.com/danielweinmann/unlock_moip) (Moip Assinaturas)
* [unlock_paypal](https://github.com/danielweinmann/unlock_paypal) (PayPal recurring)

### Creating a new gateway

Create a gem that follows the [UnlockGateway](https://github.com/danielweinmann/unlock_gateway)
pattern, integrate it with Unlock's code, and create a Pull Request.
See [Contributing](#contributing) for details on how to contribute.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`) 
3. Commit your changes (`git commit -am 'Add some feature'`) 
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

This project rocks and uses the MIT LICENSE.
