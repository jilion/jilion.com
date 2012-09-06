class Contact
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :email, :replied

  field :email,      type: String
  field :state,      type: String,  default: 'new'
  field :replied,    type: Boolean, default: false
  field :issue,      type: Integer
  field :replied_at, type: DateTime

  # CarrierWave
  mount_uploader :file, FileUploader, mount_on: :file_filename

  TYPES = %w[Contact::Job Contact::Press Contact::Request Contact::TeamUp]
  STATES = %w[new archived]

  validates :email, presence: { message: "can't be blank" }
  validates :email, length: { within: 6..100, message: "is too short" }
  validates :email, email_format: { message: "is not valid" }

  before_create :set_issue
  after_create :deliver_notification

  TYPES.each do |klass|
    define_method "#{klass.gsub(/Contact::/, '').underscore}?" do
      self.class.name == klass
    end
  end

  STATES.each do |s|
    define_method "#{s}?" do
      self.state == s
    end
  end

  def replied=(replied)
    self.replied_at = Time.now.utc if replied == '1'
  end

  def replied?
    replied_at?
  end

  def type_name
    self.class.name.gsub(/Contact::/, '').underscore
  end

  def filename
    file? ? file.file.filename : ""
  end

  def self.search(params)
    where = {}
    where[:_type] = "Contact::#{params[:type]}" if params[:type].present?
    where(where.merge(:state => params[:state] || 'new')).desc(:created_at).page(params[:page] || 1).per(25)
  end

protected

  # before_save
  def set_issue
    self.issue = Contact.count
  end

  # after_create
  def deliver_notification
    ContactMailer.notification(self).deliver!
  end

end
