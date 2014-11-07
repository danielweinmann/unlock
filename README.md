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
        
## How to contribute
Coming soon...