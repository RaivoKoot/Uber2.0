require 'data_mapper'

class TwitterUsername
  include DataMapper::Resource
 
  property :id, Serial
  property :username, String
  belongs_to :user, :required => false
end