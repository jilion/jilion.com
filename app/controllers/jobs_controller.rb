class JobsController < ApplicationController
  caches_page :index, :show

  # GET /jobs
  def index
    @jobs = Job.published
  end

  # GET /jobs/:id
  def show
    @job = Job.where(issue: params[:id].to_i).first
  end

end
