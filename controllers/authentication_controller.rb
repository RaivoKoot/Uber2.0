require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'
require 'dm-sqlite-adapter'
require 'omniauth-twitter'
require 'sinatra/flash'
require './controllers/tools/error_messages.rb'
require './controllers/tools/info_messages.rb'

use OmniAuth::Builder do
    twitter_config = TwitterInterface::getTwitterConfig
    provider :twitter, twitter_config[:consumer_key], twitter_config[:consumer_secret]
end

set :bind, '0.0.0.0'

  get '/link_twitter' do
    redirect to("/auth/twitter")
  end

  post '/unlink_twitter_account' do
      TwitterUsername.get(params[:twitter_username_id]).update(:user_id => nil)
      flash[:error] = Info::twitter_unlink_successful
      
      redirect '/profile'
  end

  get '/auth/twitter/callback' do
    if env['omniauth.auth']
        twitter_username = TwitterUsername.first_or_create(:username => env['omniauth.auth']['info']['nickname'])
        twitter_username.update(:user_id => session[:logged_user_id])
        
        
        flash[:error] = Info::twitter_link_successful
    else
        flash[:error] = Errors::twitter_link_unsuccessful
    end
      redirect '/profile'
  end

  get '/register' do
    if not session[:logged_user_id].nil?
        flash[:error] = Errors::already_logged_in
        redirect '/'
    else
        erb :register
    end
  end

  post '/register' do
    password = params[:password]
    name = params[:name]
    email = params[:email]
    
    if not User.first(:email => email).nil?
        flash[:error] = Errors::email_taken
        redirect '/register'
    end
    
    user = User.create(:name => name, 
        :password => password, 
        :email => email,
        :role => Role.first(:name => "User"))
    flash[:error] = Info::registered
    redirect '/login'
  end
  
  get '/login' do
    if not session[:logged_user_id].nil?
        flash[:error] = Errors::already_logged_in
        redirect '/'
    else
        erb :login
    end
  end

  post '/login' do
    password = params[:password]
    email = params[:email]
    
    user = User.first(:email => email)
    
    if user.nil? or user.password != password
        flash[:error] = Errors::wrong_login
        redirect '/login'
    elsif user.blocked
        flash[:error] = Errors::account_blocked
    else
        session[:logged_user_id] = user.id
        redirect '/'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end
  