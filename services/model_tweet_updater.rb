require 'data_mapper'
require 'dm-sqlite-adapter'
require 'date' 

require './services/twitter_interface.rb'

require './models/twitter_username.rb'
require './models/request.rb'
require './models/city.rb'
require './models/reply.rb'




class ModelUpdater

  def self.updateDatabase(since_id = nil)
      
     interface = TwitterInterface.new
     
     # We reverse the tweet list so that they can get registered in
     # the database from oldest to newest
     latest = interface.getLatestTweets(since_id).reverse
     
     for tweet in latest
         
         reply_to_id = tweet.in_reply_to_status_id
       
         
         if reply_to_id.nil?
            
             twitter_username = TwitterUsername.first_or_create(:username => tweet.user.screen_name)
             
             # We tried getting the city through tweet.place and tweet.geo,
             # however it always return a NullObject
             tweet_city = nil
             for city in City.all
                if tweet.text.downcase.include? city.name.downcase
                  tweet_city = city
                  break
                end
             end
            
             item = Request.first_or_create(:status_id => tweet.id, 
                                            :is_finished => false, 
                                            :twitter_username => twitter_username,
                                            :date => tweet.created_at,
                                            :city => tweet_city)
             
         else
             request_parent = Request.first(:status_id => reply_to_id)
             
             if request_parent.nil?
                 parent = Reply.first(:status_id => reply_to_id)
                 
                 if parent.nil?
                     raise "Parent not found"
                 end
                 
                 request_parent = parent.request
             end
             
             Reply.first_or_create(:status_id => tweet.id, :request => request_parent, :date => tweet.created_at)
             
         end
     end
  end
    
   def self.tweet_back(status, in_reply_to)
       
       interface = TwitterInterface.new
       tweet = interface.tweetBack(status, in_reply_to)
       request_parent = Request.first(:status_id => in_reply_to)
       
       # TODO: Optimise the parent assignment using the id only without
       # an additional request to the database
       Reply.first_or_create(:status_id => tweet.id, :request => request_parent)
   end

end

ModelUpdater::updateDatabase
