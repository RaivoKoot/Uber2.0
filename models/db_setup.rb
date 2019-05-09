require 'data_mapper'

require './models/bonus_threshold.rb'
require './models/car_type.rb'
require './models/city.rb'
require './models/driver.rb'
require './models/reply.rb'
require './models/request.rb'
require './models/role.rb'
require './models/twitter_username.rb'
require './models/user.rb'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")
DataMapper.finalize
DataMapper.auto_upgrade!

BonusThreshold.first_or_create(:name => "default", :threshold => 10)
    
user_role = Role.first_or_create(:name => "User")
moderator_role = Role.first_or_create(:name => "Moderator")
admin_role = Role.first_or_create(:name => "Admin")

User.first_or_create(:name => "Admin", :email => "admin@admin.co.uk", :password => "admin", :role_id => admin_role.id)
User.first_or_create(:name => "User", :email => "user@user.co.uk", :password => "user", :role_id => user_role.id)
User.first_or_create(:name => "moderator", :email => "moderator@moderator.co.uk", :password => "moderator", :role_id => moderator_role.id)



City.first_or_create(:name => "Sheffield")
City.first_or_create(:name => "Manchester")

CarType.first_or_create(:name => "Standard", :description => "This is our standard model car that is our cheapest and seats up to four people", :image_name => "standard.jpg")
CarType.first_or_create(:name => "Large", :description => "This car is slightly more expensive and seats up to six people.", :image_name => "large.jpg")
CarType.first_or_create(:name => "Luxury", :description => "This is our high end, luxury vehicle, providing the best experience.", :image_name => "luxury.jpg")

