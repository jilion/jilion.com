class JobsController < ApplicationController
  ssl_required :show
  caches_page :index, :show
  
  # GET /jobs
  def index
    @jobs = Job.published
  end
  
  # GET /jobs/:id
  def show
    @job = Job.first(:conditions => { :issue => params[:id].to_i })
  end
  
end