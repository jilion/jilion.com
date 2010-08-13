require 'spec_helper'

describe Admin::DelayedJobsController do
  
  it { should route(:get, "/admin/djs").to(:controller => "admin/delayed_jobs", :action => :index) }
  it { should route(:get, "/admin/djs/1").to(:controller => "admin/delayed_jobs", :action => :show, :id => 1) }
  it { should route(:put, "/admin/djs/1").to(:controller => "admin/delayed_jobs", :action => :update, :id => 1) }
  it { should route(:delete, "/admin/djs/1").to(:controller => "admin/delayed_jobs", :action => :destroy, :id => 1) }
  
end