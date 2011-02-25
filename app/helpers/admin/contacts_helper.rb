module Admin::ContactsHelper
  
  def archive_button(contact)
    render "admin/contacts/archive_button", :contact => contact
  end
  
  def reply_link(contact)
    mail_to contact.email, "Reply to this message", :subject => "Hi", :body => render("admin/replies/#{contact.type_name}", :contact => contact)
  end
  
end
