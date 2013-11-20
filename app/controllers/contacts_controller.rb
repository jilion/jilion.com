class ContactsController < ApplicationController

  # GET /contact
  def new
  end

  # POST /contacts
  def create
    @contact = contact_class.new(_contact_params)

    if @contact.save
      flash[:notice] = "Thank you for your #{job_application? ? 'application' : 'message'}."
      redirect_to new_contact_url
    elsif job_application?
      @job = Job.find(_contact_params[:job_id])
      render '/jobs/show'
    else
      render :new
    end
  end

private

  def contact_class
    type = params[:contact].delete(:type)
    if _contact_params && Contact::TYPES.include?(type)
      Contact.const_get(type)
    else
      Contact
    end
  end

  def job_application?
    _contact_params.key?(:job_id)
  end

  def _contact_params
    params.require(:contact).permit(:email, :message, :file, :file_cache, :job_id)
  end

end
