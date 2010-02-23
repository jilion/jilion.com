class ContactsController < ApplicationController
  # before_filter :admin_required
  # caches_page :new
  ssl_required :new, :create
  
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
      flash[:notice] = 'Thank you very much for your submission!'
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
