require 'spec_helper'

describe Admin::AnalyticsController do
  
  it { should route(:get,  "/admin/analytics/enthusiasts").to(:controller => "admin/analytics", :action => :index, :resources => 'enthusiasts') }
  
end