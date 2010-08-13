require 'spec_helper'

describe ContactsController do
  
  context "as guest" do
    before(:each) { session[:contact_id] = 1 }
    
    it "should respond with success to GET :show" do
      Contact.stub!(:find).with(1).and_return(Factory.create(:contact))
      get :show
      response.should be_success
    end
    it "should respond with success to GET :new" do
      get :new
      response.should be_success
    end
    it "should respond with success to POST :create" do
      post :create, :contact => { :email => "remy@jilion.com" }
      response.should redirect_to(new_contact_url)
    end
  end
  
end