class ContactsController < ApplicationController
  before_filter :admin_required
  caches_page :new
  ssl_required :new, :create
  
  # GET /contact
  def new
  end
  
  # POST /contacts
  def create
    @contact = contact_class.new(params[:contact])
    
    if @contact.save
      flash[:notice] = 'Thanks!'
      redirect_to root_url
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
