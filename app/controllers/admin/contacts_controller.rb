class Admin::ContactsController < Admin::AdminController

  has_scope :replied, :archived, type: :boolean
  has_scope :with_type, :by_issue, :by_type, :by_job, :by_created_at, :by_replied_at

  # GET /admin/contacts
  def index
    @contacts = apply_scopes(Contact).page(params[:page] || 1).per(25)
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
