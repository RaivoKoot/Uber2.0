require 'twitter'

class TwitterInterface
  
  def self.getTwitterConfig()
    return {
        :consumer_key => 'cE62oXi78ug2rxG0EoEw9AZ8u',
        :consumer_secret => 'khWkXoPT7zI3rV0VFb3lWad7Rl6nXtB9nVbjeKqga8Dahphwed',
        :access_token => '1092447903568850944-iCv3AurRvXUXEv3tPldudCiz1Dpo17',
        :access_token_secret => 'uapSJHpV1dj42GK3ZGbsRhYp44vK9BQ4jxnqT3HMb3Rbm'
    }
  end

def initialize()

    twitter_config = TwitterInterface::getTwitterConfig

    @client = Twitter::REST::Client.new(twitter_config)
  end

  def getLatestTweets(since_id = nil)
      if since_id.nil?
          return @client.mentions_timeline()
      else 
          return @client.mentions_timeline(:since_id => since_id)
      end
  end
  
  def getTweetById(id)
      begin
          tweet = @client.status(id)
          return tweet
      rescue
          return nil
      end
  end
  

  def tweetBack(status, in_reply_to)
      return @client.update(status, {:in_reply_to_status_id => in_reply_to})
  end

end
