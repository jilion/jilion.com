class Contact
  include MongoMapper::Document
  
  key :_type, String
  key :email, String, :required => true
  key :state, String, :default => 'new'
  timestamps!
  
  # CarrierWave
  mount_uploader :file, FileUploader
  
  RegEmailName   = '[\w\.%\+\-]+'
  RegDomainHead  = '(?:[A-Z0-9\-]+\.)+'
  RegDomainTLD   = '(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)'
  RegEmailOk     = /\A#{RegEmailName}@#{RegDomainHead}#{RegDomainTLD}\z/i
  TYPES = %w[Contact::Deal Contact::Job Contact::Love Contact::Press Contact::Request Contact::TeamUp]
  
  validates_length_of :email, :within => 6..100, :message => "is too short"
  validates_format_of :email, :with => RegEmailOk
  
  TYPES.each do |klass|
    define_method "#{klass.gsub(/Contact::/, '').underscore}?" do
      self.class.name == klass
    end
  end
  
  def type_name
    self.class.name.gsub(/Contact::/, '').underscore
  end
  
  def archived?
    state == "archived"
  end
  
  def self.search(params)
    options = {:state => 'new', :order => "created_at"}
    options[:_type] = params[:type] if params[:type].present?
    options[:state] = params[:state] if params[:state].present?
    all(options)
  end
  
end
