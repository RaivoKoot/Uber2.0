require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'
require 'dm-sqlite-adapter'

require './services/model_tweet_updater.rb'
require './services/twitter_interface.rb'
require './extensions.rb'
require './controllers/tools/authority_check_service.rb'

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

  get '/moderator/set_finished/*' do
    get_user_authority_check(:moderator => true)
      request_id = params[:splat][0]
      if request_id.is_i?
          @closing_request = Request.first(:status_id => request_id)
          
          @has_free_ride = false
          
          # get conversation tweets to display
          @conversation_tweets = [] 
          
          interface = TwitterInterface.new
          request = interface.getTweetById(request_id)
              if not request.nil?
                  request_model = Request.first(:status_id => request_id)
                  request_owner = request_model.twitter_username.user
                  if not request_owner.nil?
                    @has_free_ride = request_owner.points >= BonusThreshold.last.threshold - 1
                  end
                  
                  reply_models = request_model.replies
                  @request_user_name = request.user.screen_name

                  @conversation_tweets.push(request)

                  reply_models.each do |reply|
                      @conversation_tweets.push(interface.getTweetById(reply.status_id))
                  end

                  @conversation_tweets = @conversation_tweets.sort_by {|tweet| tweet.id}
              end
          
             erb :close_request
      else
          redirect to('/moderator/')
      end
  end

  post '/moderator/set_finished' do
      get_user_authority_check(:moderator => true)
       request_id = params[:request_id]
       pickup_location = params[:pickup_location]
       destination = params[:destination]
    
       request = Request.first(:status_id => request_id)
       request.update(:is_finished => true, :destination => destination, 
                                         :pickup_location => pickup_location)
      
      request_owner = request.twitter_username.user
      current_bonus_threshold = BonusThreshold.last.threshold
      
      # Give the user one point that is connected to the twitter account that made the request
      # if no user is connected to that account yet, give no points
      if not request_owner.nil?
        
          if not request_owner.points > current_bonus_threshold - 1
              request_owner.points += 1
          else
              request_owner.points -= current_bonus_threshold - 1
          end
        request_owner.save()
      end
      
      
     
       redirect to('/moderator/')
      
  end

  get '/moderator/reopen/*' do
    get_user_authority_check(:moderator => true)
      @request_id = params[:splat][0]
    
      if @request_id.is_i?
          Request.first(@request_id).update(:is_finished => false)
          
          request_owner = Request.first(:status_id => @request_id).twitter_username.user
      
          # Take one point away from the user that is connected to the twitter account that made the request
          # if no user is connected to that account yet, do nothing
          if not request_owner == nil
            
              if not request_owner.points == 0
                  request_owner.points -= 1
              end
              request_owner.save()
          end
          
          redirect to('/moderator/')
      end
  end

  # TODO: Make the replying address the latest message from the user
  # and not the request itself so that the conversation is ordered in
  # twitter
  post '/moderator/tweet_back' do
    get_user_authority_check(:moderator => true)
    reply_to_id = params[:reply_to_id]
    message = params[:message]
    request_user_name = params[:request_user_name]
    
    ModelUpdater::tweet_back('@' + request_user_name + " " + message, reply_to_id)
    
    redirect to('/moderator/' + reply_to_id)
  end
  
  get '/moderator/update_requests' do
      get_user_authority_check(:moderator => true)
      ModelUpdater::updateDatabase(Request.last().status_id)
      redirect to('/moderator/')
  end

  get '/moderator/reserve_request' do
    get_user_authority_check(:moderator => true)
      tweet_id = params[:tweet_id]
      Request.first(:status_id => tweet_id).update(:user_id => session[:logged_user_id])
      redirect to('/moderator/')
  end

  get '/moderator/unreserve_request' do
    get_user_authority_check(:moderator => true)
      tweet_id = params[:tweet_id]
      Request.first(:status_id => tweet_id).update(:user_id => nil)
      redirect to('/moderator/')
  end


  # if the parameter (request id) is passed it is used to get the
  # conversations tweets so that they can fill out the conversation pane
  # - otherwise leave it empty
  get '/moderator/*' do
      
      @logged_user = get_user_authority_check(:moderator => true).get_logged_user
    
      @current_city_id = params[:city]
 
      @new_requests =  Request.all(:is_finished => false, :user_id => nil, :city_id => @current_city_id)
      @my_requests = Request.all(:is_finished => false, :user_id => session[:logged_user_id]) # TODO: only requests belonging to this moderator
      @my_finished_requests = Request.all(:is_finished => true)
      @drivers = Driver.all
      @cities = City.all
      
      interface = TwitterInterface.new
      

      # get the request id of the conversation to display
      @conversation_id = params[:splat][0]
      @conversation_tweets = [] 
      
      if @conversation_id.is_i?
          
          request = interface.getTweetById(@conversation_id)
          unless request.nil?
              request_model = Request.first(:status_id => @conversation_id)
              reply_models = request_model.replies
              @request_user_name = request.user.screen_name

              @conversation_tweets.push(request)

              reply_models.each do |reply|
                  @conversation_tweets.push(interface.getTweetById(reply.status_id))
              end

              @conversation_tweets = @conversation_tweets.sort_by {|tweet| tweet.id}
          end
       end
      
      erb :moderator # TODO
  end
