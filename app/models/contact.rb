class Contact
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :new_type

  field :email,       type: String
  field :message,     type: String
  field :state,       type: String,  default: 'new'
  field :replied,     type: Boolean, default: false
  field :issue,       type: Integer
  field :replied_at,  type: DateTime
  field :archived_at, type: DateTime
  field :trashed_at,  type: DateTime
  field :comment,     type: String

  # CarrierWave
  mount_uploader :file, FileUploader, mount_on: :file_filename

  TYPES  = %w[Job Press Request TeamUp]

  validates :email, presence: { message: "can't be blank" }
  validates :email, length: { within: 6..100, message: "is too short" }
  validates :email, email_format: { message: "is not valid" }
  validates :message, presence: true

  before_create :set_issue
  after_create :deliver_notification

  scope :recent,         where({ :state.ne => 'archived', archived_at: nil, trashed_at: nil })
  scope :replied,        where(:replied_at.ne => nil)
  scope :archived,       any_of({ state: 'archived' }, { :archived_at.ne => nil })
  scope :trashed,        where(:trashed_at.ne => nil)
  scope :with_state,     ->(state) { where(state: state) }
  scope :_with_type,     ->(type) { type == 'all' ? where(:_type.in => TYPES.map { |t| "Contact::#{t}" }) : where(_type: "Contact::#{type}") }
  scope :by_issue,       ->(way = :desc) { order_by([:issue, way]) }
  scope :by_type,        ->(way = :asc) { order_by([:_type, way]) }
  scope :by_email,       ->(way = :asc) { order_by([:email, way]) }
  scope :by_job,         ->(way = :asc) { order_by([:job_id, way]) }
  scope :by_created_at,  ->(way = :asc) { order_by([:created_at, way]) }
  scope :by_replied_at,  ->(way = :asc) { order_by([:replied_at, way]) }
  scope :by_archived_at, ->(way = :asc) { order_by([:archived_at, way]) }
  scope :by_trashed_at,  ->(way = :asc) { order_by([:trashed_at, way]) }

  def new_type=(new_type)
    self._type = "Contact::#{new_type}" if TYPES.include?(new_type)
  end

  def replied=(replied)
    self.replied_at = Time.now.utc if replied == '1'
  end

  def archived=(archived)
    self.archived_at = Time.now if archived == '1'
  end

  def trashed=(trashed)
    self.trashed_at = Time.now if trashed == '1'
  end

  def replied?
    replied_at?
  end

  def archived?
    archived_at? || state == 'archived'
  end

  def trashed?
    trashed_at?
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
