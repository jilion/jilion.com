require 'spec_helper'

describe Admin::EnthusiastsController do
  
  it { should route(:get, "/admin/enthusiasts").to(:controller => "admin/enthusiasts", :action => :index) }
  it { should route(:get, "/admin/enthusiasts/1").to(:controller => "admin/enthusiasts", :action => :show, :id => 1) }
  
end