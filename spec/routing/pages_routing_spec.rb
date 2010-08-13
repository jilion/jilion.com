require 'spec_helper'

describe PagesController do
  
  it { should route(:get,  "/privacy").to(:controller => "pages", :action => :show, :page => 'privacy') }
  
end