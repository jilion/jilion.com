# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # include AdminAuthenticatedSystem
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
protected
  
  def cache_page
    expires_in(1.year, :public => true) if Rails.env.production?
  end
  
end