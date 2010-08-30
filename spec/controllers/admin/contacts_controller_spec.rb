require 'spec_helper'

describe Admin::ContactsController do
  
  context "as guest" do
    it "should respond with http auth to GET :index" do
      get :index
      response.should_not be_success
    end
    it "should respond with http auth to GET :show" do
      get :show, :id => '1'
      response.should_not be_success
    end
    it "should respond with http auth to PUT :update" do
      put :update, :id => '1'
      response.should_not be_success
    end
  end
  
end
