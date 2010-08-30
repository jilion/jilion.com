class ApplicationController < ActionController::Base
<<<<<<< HEAD
  # include AdminAuthenticatedSystem
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
protected
  
  def cache_page
    expires_in(1.year, :public => true) if Rails.env.production?
  end
  
end
=======
  include SslRequirement
  include AdminAuthenticatedSystem
  
  helper :all
  protect_from_forgery
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
protected
  
  def ssl_required?
    Rails.env.production?
  end
  
end
>>>>>>> 2829b84076f3bd62302e7e816ff03e75360cbeab
