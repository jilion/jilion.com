module ContactsHelper

  def contact(klass)
    if params[:contact] && params[:contact][:type] == klass
      @contact
    else
      Contact.const_get(klass).new
    end
  end

end
