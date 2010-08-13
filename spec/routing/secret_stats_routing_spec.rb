require 'spec_helper'

describe SecretStatsController do
  
  it { should route(:get,  "/stats/um2dayk8ke").to(:controller => "secret_stats", :action => :index, :format => "json") }
  
end