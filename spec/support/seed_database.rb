RSpec.configure do |config|
  module TestGateway
    module Models
      module Gateway
      end

      module Contribution
      end
    end
  end

  def get_user(name)
    @users ||= {}
    @users[name] ||= User.create!(email: "#{name}@bar.com", password: 'test123', password_confirmation: 'test123', locale: 'en', name: name.humanize)
    @users[name].reload
  end

  def get_initiative(permalink, user)
    @initiatives ||= {}
    @initiatives[permalink] ||= Initiative.create!(name: permalink.humanize, user: user, permalink: permalink)
    @initiatives[permalink].reload
  end

  def get_contribution(state)
    @contributions ||= {}
    @contributions[state] ||= Contribution.create!(user: visitor_user, initiative: unlock_initiative, value: 10, state: state, gateway: production_gateway)
    @contributions[state].reload
  end

  def get_gateway(state)
    @gateways ||= {}
    @gateways[state] ||= Gateway.create!(initiative: unlock_initiative, module_name: 'TestGateway', state: state)
    @gateways[state].reload
  end

  def the_creator_user
    get_user('the_creator')
  end

  def visitor_user
    get_user('visitor')
  end

  def unlock_initiative
    get_initiative('unlock', the_creator_user)
  end

  %w(pending active suspended).each do |state|
    define_method("#{state}_contribution") do
      get_contribution(state)
    end
  end

  %w(draft sandbox production).each do |state|
    define_method("#{state}_gateway") do
      get_gateway(state)
    end
  end

  config.before(:all) do
    # Insert all data needed for tests
    the_creator_user
    visitor_user
    unlock_initiative
  end

  config.after(:all) do
    %w(users contributions gateways initiatives).each do |table|
      ActiveRecord::Base.connection.execute "TRUNCATE #{table} CASCADE"
    end
  end
end
