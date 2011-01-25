class Job
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,       :type => String
  field :description, :type => String
  field :state,       :type => String, :default => 'new'
  field :issue,       :type => Integer

  validates_presence_of :title,       :message => "can't be blank"
  validates_presence_of :description, :message => "can't be blank"

  before_create :set_issue

  def self.published
    where(state: 'published').desc(:created_at)
  end

  def self.search(params)
    where(:state => params[:state] || 'new').desc(:created_at).paginate({ :page => params[:page] || 1, :per_page => 25 })
  end
  
  def to_param
    "#{issue}-#{title.parameterize}"
  end

  def method_missing(method, *args, &block)
    if /^(is_)?(.+)\?$/.match(method.to_s).present?
      state == $2
    end
  end

protected

  # before_save
  def set_issue
    self.issue = Job.count
  end

end