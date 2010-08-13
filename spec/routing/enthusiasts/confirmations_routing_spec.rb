require 'spec_helper'

describe Enthusiasts::ConfirmationsController do
  
  it { should route(:get,  "/notify/confirmation").to(:controller => "enthusiasts/confirmations", :action => :show) }
  
end