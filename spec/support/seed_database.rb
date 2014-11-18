RSpec.configure do |config|
  def get_user(name)
    @users ||= {}
    @users[name] ||= User.create_with(email: "#{name}@bar.com", password: 'test123', password_confirmation: 'test123', locale: 'en').find_or_create_by!(name: name.humanize)
    @users[name].reload
  end

  def get_initiative(permalink, user)
    @initiatives ||= {}
    @initiatives[permalink] ||= Initiative.create_with(name: permalink.humanize, user: user).find_or_create_by!(permalink: permalink)
    @initiatives[permalink].reload
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

  config.before(:all) do
    # Insert all data needed for tests
    the_creator_user
    visitor_user
    unlock_initiative
  end

  config.after(:all) do
    ActiveRecord::Base.connection.execute "TRUNCATE users CASCADE"
  end
end
