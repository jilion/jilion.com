require 'spec_helper'

describe EnthusiastsController do
  
  it { should route(:get,  "/").to(:controller => "enthusiasts", :action => :new) }
  it { should route(:post, "/").to(:controller => "enthusiasts", :action => :create) }
  
end