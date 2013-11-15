require 'admin_authenticated_system.rb'

class Admin::AdminController < ApplicationController
  include AdminAuthenticatedSystem
  before_filter :admin_required
  layout 'admin'
end
