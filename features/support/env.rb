require 'capybara'
require 'rspec'
require 'capybara/cucumber'
require "bundler/setup"
## Uncomment to enable SimpleCov
require 'simplecov'

SimpleCov.start do
  add_filter 'features/'
end


db_path = "#{Dir.pwd}/development.db"
puts File.exist?(db_path)
File.delete(db_path) if File.exist?(db_path)

require_relative '../../startup.rb'
require_relative '../../controllers/moderator_controller.rb'
require_relative '../../controllers/driver_controller.rb'
require_relative '../../controllers/authentication_controller.rb'
require_relative '../../controllers/user_controller.rb'
require_relative '../../controllers/cartype_controller.rb'
ENV['RACK_ENV'] = 'test'

Capybara.app = Sinatra::Application


class Sinatra::ApplicationWorld
  include RSpec::Expectations
  include RSpec::Matchers
  include Capybara::DSL
end

World do
	Sinatra::ApplicationWorld.new  
end

