require 'spec_helper'

describe JobsController do

  it { should route(:get, "/jobs/1").to(:controller => "jobs", :action => :show, :id => 1) }

end