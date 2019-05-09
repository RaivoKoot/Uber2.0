require 'data_mapper'

class Driver
    include DataMapper::Resource
    
    property :id, Serial
    property :name, Text
    property :status, Boolean
    property :car_name, String, :default => ""
    property :license_plate, String, :default => ""
    
    belongs_to :car_type
end