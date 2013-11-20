class Admin::ContactsController < Admin::AdminController
  has_scope :replied, :recent, :replied, :archived, :trashed, type: :boolean
  has_scope :_with_type, :by_issue, :by_type, :by_email, :by_job, :by_created_at, :by_replied_at, :by_archived_at, :by_trashed_at

  # GET /admin/contacts
  def index
    params[:recent]   = true unless params[:replied] || params[:archived] || params[:trashed] || params[:_with_type]
    params[:by_issue] = 'desc' unless params.keys.detect { |k| k =~ /^by_/ }
    @contacts = apply_scopes(Contact).page(params[:page] || 1).per(25)
  end

  # GET /admin/contacts/:id
  def show
    @contact = Contact.find(params[:id])
  end

  # PUT /contacts/:id
  def update
    @contact = Contact.find(params[:id])

    if @contact.update_attributes(_contact_params)
      flash[:notice] = 'Updated.'
      redirect_to admin_contacts_path
    else
      render :show
    end
  end

  private

  def _contact_params
    params.require(:contact).permit!
  end

end
