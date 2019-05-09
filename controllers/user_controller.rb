require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'
require 'dm-sqlite-adapter'

require './controllers/tools/authority_check_service.rb'
require './controllers/tools/authority_check.rb'
require './controllers/tools/error_messages.rb'
require './controllers/tools/info_messages.rb'


set :bind, '0.0.0.0'
  
  # This function is copied throughout the controllers because
  # we could not find a way to do a redirect from outside of the
  # controller itself
  def get_user_authority_check(moderator = false, admin = false)
    if moderator
      authority_check = AuthorityCheckService::get_moderator(session, admin)
    else
      authority_check = AuthorityCheckService::get_logged_user(session)
    end
    
    if(not authority_check.get_is_successful)
        flash[:error] = Errors::not_authenticated
      redirect authority_check.get_redirect
    end
    return authority_check
  end

  get '/user' do
    
      @logged_user = get_user_authority_check(:moderator => true).get_logged_user
      
      @name_filter = params[:name_filter]
      @email_filter = params[:email_filter]

      @users = User.all(:name.like => "%#{@name_filter}%", :email.like => "%#{@email_filter}%")
      
      erb :users
  end

  post '/user/block' do
    get_user_authority_check(:moderator => true)
      id = params[:user_id]
      User.first(:id => id).update(:blocked => true)
      
      redirect '/user'
  end

  post '/user/unblock' do
    get_user_authority_check(:moderator => true)
      id = params[:user_id]
      User.first(:id => id).update(:blocked => false)
      
      redirect '/user'
  end

  post '/user/promote' do
    get_user_authority_check(:moderator => true, :admin => true)
      id = params[:user_id]
      User.first(:id => id).update(:role => Role.first(:name => "Moderator"))
      
      redirect '/user'
  end

  post '/user/demote' do
    get_user_authority_check(:moderator => true, :admin => true)
      id = params[:user_id]
      User.first(:id => id).update(:role => Role.first(:name => "User"))
      
      redirect '/user'
  end

  post '/user/give_free_ride' do
      get_user_authority_check(:moderator => true)
      
      id = params[:user_id]
      user = User.first(:id => id)
      current_bonus_treshold = BonusThreshold.last.threshold
      
      user.points += current_bonus_treshold
      user.save()
      
      redirect '/user'
  end

  get '/profile' do
      @logged_user = get_user_authority_check.get_logged_user
    
    
      unless @logged_user.nil?
          @free_ride_points = @logged_user.points
          @free_ride_threshold = BonusThreshold.last().threshold
          
          @twitter_usernames = TwitterUsername.all(:user => @logged_user)
          @journeys = Request.all(:twitter_username => @logged_user.twitter_usernames, :is_finished => true)
          erb :profile
      else
          redirect '/login'
      end
  end

  post '/user/change_password' do
      @logged_user = get_user_authority_check.get_logged_user
      old_password = params[:old_password]
      new_password = params[:new_password]
      new_password_confirm = params[:new_password_confirm]
      
      if @logged_user.password == old_password
          if new_password == new_password_confirm
              @logged_user.update(:password => new_password)
          else
              flash[:error] = Errors::wrong_password_confirmation
          end
      else
          flash[:error] = Errors::wrong_old_password
      end
      
      redirect '/profile'
  end

  post '/user/change_email' do
      @logged_user = get_user_authority_check.get_logged_user
      new_email = params[:new_email]
      
      if not User.first(:email => new_email).nil?
        flash[:error] = Errors::email_taken
      else
          flash[:error] = Info::email_change_successful
          @logged_user.update(:email => new_email)
      end
      
      redirect '/profile'
  end

  post '/user/change_name' do
      @logged_user = get_user_authority_check.get_logged_user
      new_name = params[:new_name]
      @logged_user.update(:name => new_name)
      flash[:error] = Info::name_change_successful
      
      redirect '/profile'
  end

  