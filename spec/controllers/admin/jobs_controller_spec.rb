require 'spec_helper'

pending Admin::JobsController do
  
  # context "with logged in admin" do
  #   before :each do
  #     @mock_admin = mock_model(Admin)
  #     Admin.stub(:find).and_return(@mock_admin)
  #     sign_in :admin, @mock_admin
  #   end
  #   
  #   it "should respond with success to GET :index" do
  #     Delayed::Job.stub_chain(:order, :all).and_return([])
  #     get :index
  #     response.should be_success
  #   end
  #   
  #   it "should respond with success to GET :show" do
  #     Delayed::Job.stub(:find).with(1).and_return(mock_dj)
  #     get :show, :id => 1
  #     response.should be_success
  #   end
  #   
  #   pending "should respond with success to PUT :update" do
  #     
  #   end
  #   
  #   pending "should respond with success to DELETE :destroy" do
  #     
  #   end
  # end
  
  context "as guest" do
    it "should respond with http auth to GET :index" do
      get :index
      response.should_not be_success
    end
    it "should respond with http auth to GET :show" do
      get :show, :id => '1'
      response.should_not be_success
    end
    it "should respond with http auth to GET :new" do
      get :new
      response.should_not be_success
    end
    it "should respond with http auth to POST :create" do
      post :create, :job => {}
      response.should_not be_success
    end
    it "should respond with http auth to GET :edit" do
      get :edit, :id => '1'
      response.should_not be_success
    end
    it "should respond with http auth to PUT :update" do
      put :update, :id => '1'
      response.should_not be_success
    end
  end
  
end