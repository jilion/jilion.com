class ContactMailer < ActionMailer::Base
  layout 'standard'
  
  def notification(contact)
    recipients  "info@jilion.com"
    from        "noreply@jilion.com"
    subject     "New contact (#{contact.type_name.humanize}) - ##{contact.issue}"
    body        :contact => contact
  end
  
end