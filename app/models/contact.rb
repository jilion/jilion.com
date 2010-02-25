class Contact
  include MongoMapper::Document
  
  key :_type, String
  key :email, String
  key :state, String, :default => 'new'
  key :replied, Boolean
  key :issue, Integer
  timestamps!
  
  # CarrierWave
  mount_uploader :file, FileUploader
  
  RegEmailName   = '[\w\.%\+\-]+'
  RegDomainHead  = '(?:[A-Z0-9\-]+\.)+'
  RegDomainTLD   = '(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)'
  RegEmailOk     = /\A#{RegEmailName}@#{RegDomainHead}#{RegDomainTLD}\z/i
  TYPES = %w[Contact::Deal Contact::Job Contact::Love Contact::Press Contact::Request Contact::TeamUp]
  
  validates_presence_of :email, :message => "can't be blank"
  validates_length_of   :email, :within  => 6..100, :message => "is too short"
  validates_format_of   :email, :with    => RegEmailOk, :message => "is not valid"
  
  before_save :set_issue
  # after_create :deliver_notification
  
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
    options = {:state => 'new', :order => "created_at desc", :page => params[:page]}
    options[:_type] = params[:type] if params[:type].present?
    options[:state] = params[:state] if params[:state].present?
    paginate(options.merge(:per_page => 25))
  end
  
protected
  
  # before_save
  def set_issue
    self.issue = Contact.count
  end
  
  # after_create
  def deliver_notification
    ContactMailer.deliver_notification(self)
  end
  
end
