require 'data_mapper'

class CarType
    include DataMapper::Resource
    
    property :id, Serial
    property :name, String
    property :description, Text
    property :image_name, Text
    property :active, Boolean, :default => true
end