class Job
  include MongoMapper::Document
  
  key :title, String, :required => true
  key :description, String, :required => true
  key :state, String, :default => 'new'
  key :issue, Integer
  timestamps!
  
  before_create :set_issue
  
  def self.published
    self.all(:conditions => { :state => 'published' }, :order => "created_at desc")
  end
  
  def self.search(params)
    options = { :state => 'new', :order => "created_at desc", :page => params[:page] }
    options[:state] = params[:state] if params[:state].present?
    paginate(options.merge(:per_page => 25))
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