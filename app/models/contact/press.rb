class Contact::Press < Contact

  field :message, :type => String

  validates_presence_of :message

end
