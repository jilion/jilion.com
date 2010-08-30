class PagesController < ApplicationController
  before_filter :cache_page
  
  def home
  end
  
  def ie
    render :layout => false
  end
  
end
