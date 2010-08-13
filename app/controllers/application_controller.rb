class ApplicationController < ActionController::Base
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
