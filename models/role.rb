require 'data_mapper'

class Role
    include DataMapper::Resource
    
    property :id, Serial
    property :name, Text
    
    has n,  :users
end