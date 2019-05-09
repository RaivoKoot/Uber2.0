require 'data_mapper'

class BonusThreshold
    include DataMapper::Resource
    
    property :id, Serial
    property :threshold, Integer
    property :name, String
end