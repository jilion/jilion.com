class ContactMailer < ActionMailer::Base

  def notification(contact)
    @contact = contact
    mail(
      :to => ["mehdi@jilion.com", "zeno@jilion.com"],
      :from => ["noreply@jilion.com"],
      :subject => "New contact (#{contact.type_name.humanize}) from #{contact.email}"
    )
  end

end
