ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # login_url = 
  # logout_url = '/logout'

  
  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  def login_as(user)
    post '/login', params: {name: user.name, password: 'secret'}
  end

  def logout
    delete '/logout'
  end

  def setup
    login_as(users(:one))
  end 

end