class ApplicationController < ActionController::Base
  # include AdminAuthenticatedSystem
  protect_from_forgery
  
protected
  
  def cache_page
    expires_in(1.year, :public => true) if Rails.env.production?
  end
  
end
