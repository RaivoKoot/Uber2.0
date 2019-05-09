class Errors
    
    def self.wrong_login()
        return "The login credentials are incorrect"
    end
    
    def self.account_blocked()
        return "Sorry, your account has been blocked"
    end
    
    def self.email_taken()
        return "Sorry, a user with that e-mail already exists"
    end
    
    def self.already_logged_in()
        return "You are already logged in"
    end
    
    def self.twitter_link_unsuccessful()
        return "There was something wrong linking your twitter account"
    end
    
    def self.wrong_password_confirmation()
        return "The confirmation for the password did not match"
    end
    
    def self.wrong_old_password()
        return "The old password you entered is incorrect"
    end
    
    def self.driver_deletion_unsuccsessful()
        return "Something went wrong deleting that driver"
    end
    
    def self.driver_addition_unsuccessful()
        return "Something went wrong adding that driver"
    end
    
    def self.add_cartype_failed()
        return "Something went wrong adding that car type"
    end
    
    def self.not_authenticated()
        return "You don't have the correct authentication to access that page"
    end
    
end