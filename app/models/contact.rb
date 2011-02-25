require 'carrierwave/orm/mongoid'

class Contact
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email,   :type => String
  field :state,   :type => String,  :default => 'new'
  field :replied, :type => Boolean, :default => false
  field :issue,   :type => Integer

  # CarrierWave
  mount_uploader :file, FileUploader

  RegEmailName   = '[\w\.%\+\-]+'
  RegDomainHead  = '(?:[A-Z0-9\-]+\.)+'
  RegDomainTLD   = '(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)'
  RegEmailOk     = /\A#{RegEmailName}@#{RegDomainHead}#{RegDomainTLD}\z/i
  TYPES = %w[Contact::Job Contact::Press Contact::Request Contact::TeamUp]
  STATES = %w[new archived]

  validates_presence_of :email,                        :message => "can't be blank"
  validates_length_of   :email, :within => 6..100,     :message => "is too short"
  validates_format_of   :email, :with   => RegEmailOk, :message => "is not valid"

  before_create :set_issue
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

  def filename
    file? ? file.file.filename : ""
  end

  def self.search(params)
    where = {}
    where[:_type] = params[:type] if params[:type].present?
    where(where.merge(:state => params[:state] || 'new')).desc(:created_at).paginate({ :page => params[:page] || 1, :per_page => 25 })
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
