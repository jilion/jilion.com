class PagesController < ApplicationController
  caches_page :home, :ie
  
  def home
  end
  
  def ie
    render :layout => false
  end
  
end
