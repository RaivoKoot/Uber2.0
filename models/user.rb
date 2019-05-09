require 'data_mapper'

class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :email, String, :unique => true
  property :password, BCryptHash
  property :blocked, Boolean, :default => false
  property :points, Integer, :default => 0, :required => true
    
  belongs_to :role
  has n, :twitter_usernames
  has n, :requests # Requests that a moderator is working on
end