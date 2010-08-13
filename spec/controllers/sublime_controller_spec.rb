require 'spec_helper'

describe SecretStatsController do
  
  context "as guest" do
    it "should respond with success to GET :index" do
      get :index, :format => "json"
      response.should be_success
    end
  end
  
end