module Admin::ContactsHelper

  def reply_link(contact)
    mail_to(
      contact.email,
      "Reply to this message",
      :body => "\n\n#{contact.message}"
    )
  end

end
