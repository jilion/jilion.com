class ContactsController < ApplicationController

  # GET /contact
  def new
  end

  # POST /contacts
  def create
    @contact = contact_class.new(params[:contact])

    if @contact.save
      flash[:notice] = "Thank you for your #{job_application? ? 'application' : 'message'}."
      redirect_to new_contact_url
    elsif job_application?
      @job = Job.find(params[:contact][:job_id])
      render '/jobs/show'
    else
      render :new
    end
  end

private

  def contact_class
    type = params[:contact].delete(:type)
    if params[:contact] && Contact::TYPES.include?(type)
      Contact.const_get(type)
    else
      Contact
    end
  end

  def job_application?
    params[:contact].key?(:job_id)
  end

end
