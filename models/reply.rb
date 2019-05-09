require 'data_mapper'

class Reply
    include DataMapper::Resource
    property :id, Serial
    property :status_id, String
    property :date, DateTime
  
    belongs_to :request
end