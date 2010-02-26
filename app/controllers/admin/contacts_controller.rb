class Admin::ContactsController < ApplicationController
  ssl_required :index, :show, :update
  before_filter :admin_required
  layout 'admin'
  
  # GET /admin/contacts
  def index
    @contacts = Contact.search(params)
  end
  
  # GET /admin/contacts/:id
  def show
    @contact = Contact.find(params[:id])
  end
  
  # PUT /contacts/:id
  def update
    @contact = Contact.find(params[:id])
    
    if @contact.update_attributes(params[:contact])
      flash[:notice] = 'Updated.'
      redirect_to admin_contacts_path
    else
      render :show
    end
  end
  
end
