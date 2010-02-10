# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include SslRequirement
  include AdminAuthenticatedSystem
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  skip_before_filter :ensure_proper_protocol unless Rails.env.production?
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
