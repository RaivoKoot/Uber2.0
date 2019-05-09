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
      flash[:error] = Errors::not_authenticated
      redirect authority_check.get_redirect
    end
    return authority_check
  end

  post '/drivers/add' do
    get_user_authority_check(:moderator => true)
    driver_name = params[:driver_name]
    car_name = params[:car_name]
    car_type_name = params[:car_type]
    license_plate = params[:license_plate]
    
      begin
        car_type = CarType.first(:name => car_type_name)
        driver = Driver.create(:name => driver_name, :car_name => car_name, :license_plate => license_plate, :car_type => car_type)
        flash[:error] = Info::driver_added_successfully
      rescue
        flash[:error] = Errors::driver_addition_unsuccessful
      ensure
          redirect to('/drivers')
      end
  end


  delete '/drivers/delete' do
    get_user_authority_check(:moderator => true)
    driver_id = params[:driver_id]
    
      begin
        Driver.first(:id => driver_id).destroy
        flash[:error] = Info::driver_deletion_successful
      rescue
          flash[:error] = Errors::driver_deletion_unsuccessful
      ensure
          redirect to('/drivers')
      end
      
  end

  get '/drivers' do
    @logged_user = get_user_authority_check(:moderator => true).get_logged_user
    @drivers = Driver.all
    @car_types = CarType.all
    
    erb :drivers
  end

 post '/drivers/changeStatus' do
   get_user_authority_check(:moderator => true)
    driver_id = params[:driver_id]
    driver = Driver.first(driver_id)
    driver_status = driver.status
     
    driver.update(:status => (not driver_status))
    redirect to('/moderator/')
  end

    