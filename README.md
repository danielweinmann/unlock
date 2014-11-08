# Unlock [![Code Climate](https://codeclimate.com/github/danielweinmann/unlock/badges/gpa.svg)](https://codeclimate.com/github/danielweinmann/unlock)

Unlock people's pontential through recurring crowdfunding.

## Installing
Before installing make sure you have the necessary software installed in your computer:

  * Ruby 2.0+
  * PostgreSQL 9.3+ (with the postgresql contrib modules)
  
Simple and quick:

  1. Just clone the repo and get in the directory:

		git clone git@github.com:danielweinmann/unlock.git
		cd unlock
    
  2. Install the gems (you might need to adjust the ruby version in the Gemfile):
  
  		bundle
  		
  3. Create the database configuration file, create the database and run the migrations:

        cp config/database.sample.yml config/database.yml
        rake db:setup

## Payment gateways

Every initiative on Unlock can add and configure multiple payment gateways, which are separated gems that follows the [UnlockGateway](https://github.com/danielweinmann/unlock_gateway) pattern.

### Available gateways

[unlock_moip](https://github.com/danielweinmann/unlock_moip) (Moip Assinaturas)

[unlock_paypal](https://github.com/danielweinmann/unlock_paypal) (PayPal recurring)

### Creating a new gateway

Just create a gem that follows the [UnlockGateway](https://github.com/danielweinmann/unlock_gateway) pattern, integrate it with Unlock's code, and create a a Pull Request. Se "Contributing" for details on how to contribute.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


This project rocks and uses MIT-LICENSE.
