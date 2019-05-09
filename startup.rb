require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
require './models/db_setup.rb'
require 'erb'

include ERB::Util

require_relative 'controllers/moderator_controller.rb'
require_relative 'controllers/driver_controller.rb'
require_relative 'controllers/authentication_controller.rb'
require_relative 'controllers/user_controller.rb'
require_relative 'controllers/cartype_controller.rb'

enable :sessions
set :session_secret, 'super secret'

get '/' do
    @logged_user = User.first(:id => session[:logged_user_id])
    @free_ride_threshold = BonusThreshold.last().threshold
    
    erb :index
end