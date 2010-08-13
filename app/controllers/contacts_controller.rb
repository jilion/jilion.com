class ContactsController < ApplicationController
  ssl_required :show, :new, :create
  # caches_page :new
  
  # GET /contact/Jilion-contact.pdf
  def show
    @contact = Contact.find(session[:contact_id])
    
    respond_to do |format|
      if @contact
        format.pdf
      else
        format.html { redirect_to new_contact_path }
      end
    end
  end
  
  # GET /contact
  def new
  end
  
  # POST /contacts
  def create
    @contact = contact_class.new(params[:contact])
    session.delete(:contact_id)
    
    if @contact.save
      flash[:notice] = 'Thank you for your message.'
      session[:contact_id] = @contact.id if @contact.deal?
      redirect_to new_contact_url
    else
      render :new
    end
  end
  
private
  
  def contact_class
    if params[:contact] && Contact::TYPES.include?(params[:contact][:_type])
      class_eval(params[:contact][:_type])
    else
      Contact
    end
  end
  
end