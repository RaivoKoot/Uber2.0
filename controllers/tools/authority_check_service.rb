require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'data_mapper'
require 'dm-sqlite-adapter'

require './controllers/tools/authority_check_service.rb'
require './controllers/tools/error_messages.rb'

class AuthorityCheckService
	def self.check_authority(authority_check, admin)
    
		role_name = authority_check.get_logged_user.role.name
    authority_check.set_is_successful false
    authority_check.set_redirect "/"
    
    if(admin)
      if not (role_name == "Admin")
        return authority_check
      end
    elsif not (role_name == "Moderator" or role_name == "Admin")
      return authority_check
    end
    
    authority_check.set_is_successful true
    return authority_check
	end
  
  
	def self.check_authentication(session)
    
    authority_check = AuthorityCheck.new
    
		if session[:logged_user_id].nil?
			authority_check.set_is_successful false
            
            
      authority_check.set_redirect "/login"
    else
      authority_check.set_is_successful true
    end
    
    return authority_check
	end
  
	def self.get_logged_user(session)
		authority_check = check_authentication(session)
    
    if(authority_check.get_is_successful)
      authority_check.set_logged_user User.first(:id => session[:logged_user_id])
    end
    
    return authority_check
	end
		# We need to get the moderator to check authority for each
	# method because the class does not store the value of @logged_user
	# in between requests. We tried to store it in a session but then we
	# have the problem that whenever a property of that user is changed
	# (Role, Name, Email, etc) the session needs to be updated and
	# there is no way for us to change a specific user's session.
	def self.get_moderator(session, admin = false)
    authority_check = get_logged_user(session)
    
    if(authority_check.get_is_successful)
		  check_authority(authority_check, admin)
    end
    
    return authority_check
end
end