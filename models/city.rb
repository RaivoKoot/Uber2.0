require 'data_mapper'

class City
  include DataMapper::Resource
    
  property :id, Serial
  property :name, String
  
  has n, :requests
end