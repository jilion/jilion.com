require 'spec_helper'

describe Contact::Request do
  
  describe "valid" do
    subject { Factory(:request) }
    
    its(:email)   { should match /email[0-9]+@jilion.com/ }
    its(:state)   { should == "new" }
    its(:replied) { should == false }
    its(:issue)   { should be_nil }
    its(:message) { should == "A message" }
    
    it { should be_request }
    it { should be_new }
    it { should be_valid }
  end
  
  describe "Validations" do
    it { should validate_presence_of(:message) }
  end
  
  describe "#type_name" do
    specify { Factory(:request).type_name.should == "request" }
  end
  
end
