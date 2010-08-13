require 'spec_helper'

describe PagesController do
  
  context "as guest" do
    it "should respond with success to GET :show" do
      get :show, :page => 'privacy'
      response.should be_success
    end
  end
  
end