class ContactsController < ApplicationController

  # GET /contact
  def new
  end

  # POST /contacts
  def create
    @contact = contact_class.new(params[:contact])

    if @contact.save
      flash[:notice] = 'Thank you for your message.'
      redirect_to new_contact_url
    elsif params[:contact][:job_id]
      @job = Job.find(params[:contact][:job_id])
      render '/jobs/show'
    else
      render :new
    end
  end

private

  def contact_class
    if params[:contact] && Contact::TYPES.include?(params[:contact][:type])
      Contact.const_get(params[:contact][:type])
    else
      Contact
    end
  end

end
