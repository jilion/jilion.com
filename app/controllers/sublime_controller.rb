class SublimeController < ApplicationController
  caches_page :show
  
  def index
    redirect_to sublime_path(:video)
  end
  
  def show
    render params[:id]
  end
  
end
