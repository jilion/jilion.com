require 'spec_helper'

describe ContactsController do
  mock_model :contact
  
  context "as guest" do
    before(:each) { session[:contact_id] = 1 }
    
    it "should respond with success to GET :show" do
      Contact.stub!(:find).with(1).and_return(mock_contact)
      get :show
      response.should be_success
    end
    it "should respond with success to GET :new" do
      get :new
      response.should be_success
    end
    it "should respond with success to POST :create" do
      post :create, :contact => {}
      response.should redirect_to(root_path)
    end
  end
  
end