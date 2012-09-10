module ContactsHelper

  def contact(klass)
    if @contact && @contact.type_name == klass.underscore
      @contact
    else
      Contact.const_get(klass).new
    end
  end

end
