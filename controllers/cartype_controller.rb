require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'data_mapper'
require 'dm-sqlite-adapter'

require './controllers/tools/error_messages.rb'
require './controllers/tools/info_messages.rb'


set :bind, '0.0.0.0'

  # This function is copied throughout the controllers because
  # we could not find a way to do a redirect from outside of the
  # controller itself
  def get_user_authority_check(moderator = false, admin = false)
    if moderator
      authority_check = AuthorityCheckService::get_moderator(session, admin)
    else
      authority_check = AuthorityCheckService::get_logged_user(session)
    end
    
    if(not authority_check.get_is_successful)
      redirect authority_check.get_redirect
    end
    return authority_check
  end

  post '/cartypes/add' do
    get_user_authority_check(:moderator => true, :admin =>  true)
    cartype_name = params[:cartype_name]
    cartype_description = params[:description]
    
    begin
        # saves the given image to the public folder
        filename = params[:file][:filename]
        file = params[:file][:tempfile]
        File.open("./public/images/#{filename}", 'wb') do |f|
            f.write(file.read)
        end

        car_type = CarType.create(:name => cartype_name, :description => cartype_description, :image_name => filename)
        
        flash[:error] = Info::add_cartype_successful
    rescue
        flash[:error] = Errors::add_cartype_failed
    ensure
        redirect to('/cartypes')
    end
  end

 post '/cartypes/activate' do
       get_user_authority_check(:moderator => true, :admin =>  true)
      id = params[:cartype_id]
      CarType.first(:id => id).update(:active => true)
      
      redirect '/cartypes'
  end

  post '/cartypes/deactivate' do
    get_user_authority_check(:moderator => true, :admin =>  true)
      id = params[:cartype_id]
      CarType.first(:id => id).update(:active => false)
      
      redirect '/cartypes'
  end


  get '/cartypes' do
    @logged_user = User.first(:id => session[:logged_user_id])
    @cartypes = CarType.all
    
    erb :cartypes
  end


    