class Admin::JobsController < ApplicationController
  ssl_required :index, :show, :new, :create, :edit, :update, :destroy
  before_filter :admin_required
  layout 'admin'
  
  # GET /admin/jobs
  def index
    @jobs = Job.search(params)
  end
  
  # GET /admin/jobs/:id
  def show
    @job = Job.find(params[:id])
  end
  
  # GET /admin/jobs/new
  def new
    @job = Job.new
  end
  
  # POST /admin/jobs
  def create
    @job = Job.new(params[:job])
    
    if @job.save
      flash[:notice] = 'Saved.'
      redirect_to admin_jobs_path
    else
      render :new
    end
  end
  
  # GET /admin/jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end
  
  # PUT /admin/jobs/:id
  def update
    @job = Job.find(params[:id])
    
    if @job.update_attributes(params[:job])
      flash[:notice] = 'Updated.'
      redirect_to "#{admin_jobs_path}?state=#{@job.state}"
    else
      render :edit
    end
  end
  
end
