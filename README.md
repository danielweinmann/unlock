# Unlock [![Build Status](https://secure.travis-ci.org/danielweinmann/unlock.png?branch=master)](https://travis-ci.org/danielweinmann/unlock) [![Code Climate](https://codeclimate.com/github/danielweinmann/unlock/badges/gpa.svg)](https://codeclimate.com/github/danielweinmann/unlock)

Unlock people's pontential through recurring crowdfunding.

## Installing

Before installing, make sure you have recent versions of [Git](http://www.git-scm.com/),
[Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) 
installed on your development machine.

Then, simply clone the repository:

```
git clone git@github.com:danielwinmann/unlock.git
```

And create a Vagrant machine from the root of the project:

```
cd unlock
vagrant up
```

This will download and install all the required dependencies, and set up the database for you.
To make sure everything worked well, try running the tests:

```
vagrant ssh -c 'cd /vagrant && rake'
```

And then running the application:

```
vagrant ssh -c 'cd /vagrant && rails server'
```

## Payment gateways

Every initiative on Unlock can add and configure multiple payment gateways, which are separated gems that follows the [UnlockGateway](https://github.com/danielweinmann/unlock_gateway) pattern.

### Available gateways

[unlock_moip](https://github.com/danielweinmann/unlock_moip) (Moip Assinaturas)

[unlock_paypal](https://github.com/danielweinmann/unlock_paypal) (PayPal recurring)

### Creating a new gateway

Just create a gem that follows the [UnlockGateway](https://github.com/danielweinmann/unlock_gateway) pattern, integrate it with Unlock's code, and create a Pull Request. Se [Contributing](#contributing) for details on how to contribute.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

This project rocks and uses MIT-LICENSE.
