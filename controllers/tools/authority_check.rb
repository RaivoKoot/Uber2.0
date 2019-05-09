
class AuthorityCheck
  def initialize()
    @is_successful = nil
    @redirect = nil
    @logged_user = nil   
  end
  
  def set_is_successful(value)
    @is_successful = value
  end
  
  def get_is_successful
    return @is_successful
  end
  
  def set_redirect(value)
    @redirect = value
  end
  
  def get_redirect
    return @redirect
  end
  
  def set_logged_user(value)
    @logged_user = value
  end
  
  def get_logged_user
    return @logged_user
  end
end