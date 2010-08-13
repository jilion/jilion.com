class Admin::AdminController < ApplicationController
  ssl_required
  layout 'admin'
  before_filter :admin_required
end