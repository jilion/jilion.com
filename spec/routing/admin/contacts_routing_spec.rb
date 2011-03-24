require 'spec_helper'

describe Admin::ContactsController do

  it { should route(:get, "/admin/contacts").to(:controller => "admin/contacts", :action => :index) }
  it { should route(:get, "/admin/contacts/1").to(:controller => "admin/contacts", :action => :show, :id => 1) }
  it { should route(:put, "/admin/contacts/1").to(:controller => "admin/contacts", :action => :update, :id => 1) }

end