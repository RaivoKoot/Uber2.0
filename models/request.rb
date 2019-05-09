require 'data_mapper'

class Request
    include DataMapper::Resource
    
    property :id, Serial
    property :status_id, String
    property :is_finished, Boolean, :default => false
    property :pickup_location, String, :default => ""
    property :destination, String, :default => ""
    property :date, DateTime
    
    belongs_to :twitter_username
    belongs_to :user, :required => false # The moderator that is working on the request
    belongs_to :city, :required => false
    has n, :replies
end