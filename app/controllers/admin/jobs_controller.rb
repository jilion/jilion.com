class Admin::JobsController < Admin::AdminController
  
  # GET /admin/jobs
  def index
    params[:state] = 'published' unless params[:state]
    @jobs = Job.search(params)
  end
  
  # GET /admin/jobs/:id
  def show
    @job = Job.where(issue: params[:id].to_i).first
  end
  
  # GET /admin/jobs/new
  def new
    @job = Job.new
  end
  
  # POST /admin/jobs
  def create
    @job = Job.new(params[:job])
    
    if @job.save
      redirect_to(admin_jobs_path, notice: "Saved.")
    else
      render :new
    end
  end
  
  # GET /admin/jobs/1/edit
  def edit
    @job = Job.where(issue: params[:id].to_i).first
  end
  
  # PUT /admin/jobs/:id
  def update
    @job = Job.where(issue: params[:id].to_i).first
    
    if @job.update_attributes(params[:job])
      redirect_to(admin_jobs_path(state: @job.state), notice: "Updated.")
    else
      render :edit
    end
  end
  
end