class ContactsController < ApplicationController
  caches_page :new
  ssl_required :new, :create
  
  # GET /contact
  def new
  end
  
  # POST /contacts
  def create
    @contact = Contact.new(params[:contact])
    
    if @contact.save
      flash[:notice] = 'Thanks!'
      redirect_to root_url
    else
      render :new
    end
  end
  
end
