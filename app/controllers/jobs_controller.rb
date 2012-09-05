class JobsController < ApplicationController
  caches_page :index, :show

  # GET /jobs/:id
  def show
    @job = Job.where(issue: params[:id].to_i).first
    admin_required unless @job.is_published?
  end

end
