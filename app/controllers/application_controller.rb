class ApplicationController < ActionController::Base
  include AdminAuthenticatedSystem
  protect_from_forgery
end
