module ContactsHelper

  def contact(klass)
    if @contact && @contact.type_name == klass.underscore
      @contact
    else
      Contact.const_get(klass).new
    end
  end

  def short_contact_type(contact)
    contact.class.name.gsub(/Contact::/, '')
  end

end
