class Contact
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :email, :type, :message, :file, :replied, :archived, :comment

  field :email,       type: String
  field :message,     type: String
  field :state,       type: String,  default: 'new'
  field :replied,     type: Boolean, default: false
  field :issue,       type: Integer
  field :replied_at,  type: DateTime
  field :archived_at, type: DateTime
  field :comment,     type: String

  # CarrierWave
  mount_uploader :file, FileUploader, mount_on: :file_filename

  TYPES = %w[Job Press Request TeamUp]
  STATES = %w[new]

  validates :email, presence: { message: "can't be blank" }
  validates :email, length: { within: 6..100, message: "is too short" }
  validates :email, email_format: { message: "is not valid" }
  validates :message, presence: true

  before_create :set_issue
  after_create :deliver_notification

  scope :replied,       where(:replied_at.ne => nil)
  scope :archived,      where({ state: 'archived' } || { :archived_at.ne => nil })
  scope :with_state,    ->(state) { where(state: state) }
  scope :with_type,     ->(type) { where(type: "Contact::#{type}") }
  scope :by_issue,      ->(way = :desc) { order_by([:issue, way]) }
  scope :by_type,       ->(way = :asc) { order_by([:type, way]) }
  scope :by_job,        ->(way = :asc) { order_by([:job_id, way]) }
  scope :by_created_at, ->(way = :asc) { order_by([:created_at, way]) }
  scope :by_replied_at, ->(way = :asc) { order_by([:replied_at, way]) }

  TYPES.each do |klass|
    define_method "#{klass.underscore}?" do
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

  def archived=(archived)
    self.archived_at = Time.now if archived == '1'
  end

  def archived?
    archived_at? || state == 'archived?'
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
