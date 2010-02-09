class Contact
  include MongoMapper::Document
  
  key :_type, String
  key :email, String, :required => true
  key :state, String
  timestamps!
  
  # CarrierWave
  mount_uploader :file, FileUploader
  
  RegEmailName   = '[\w\.%\+\-]+'
  RegDomainHead  = '(?:[A-Z0-9\-]+\.)+'
  RegDomainTLD   = '(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)'
  RegEmailOk     = /\A#{RegEmailName}@#{RegDomainHead}#{RegDomainTLD}\z/i
  
  validates_length_of :email, :within => 6..100, :message => "is too short"
  validates_format_of :email, :with => RegEmailOk
  
end
