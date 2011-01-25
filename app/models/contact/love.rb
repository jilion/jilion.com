class Contact::Love < Contact

  field :message, :type => String

  validates_presence_of :message

end
