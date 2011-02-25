require 'spec_helper'

describe PagesController do

  it { should route(:get, "/n/thankyou").to(:controller => "pages", :action => :show, :page => 'home', :n => 'thankyou') }
  it { should route(:get, "/n/confirmed").to(:controller => "pages", :action => :show, :page => 'home', :n => 'confirmed') }
  it { should route(:get, "/n/unsubscribed").to(:controller => "pages", :action => :show, :page => 'home', :n => 'unsubscribed') }

end