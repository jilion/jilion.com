require 'spec_helper'

describe PagesController do

  context "as guest" do
    it "should respond with success to GET :index" do
      get :show, :page => "home", :n => 'thankyou'
      response.should be_success
    end
    it "should respond with success to GET :index" do
      get :show, :page => "home", :n => 'confirmed'
      response.should be_success
    end
    it "should respond with success to GET :index" do
      get :show, :page => "home", :n => 'unsubscribed'
      response.should be_success
    end
  end

end
