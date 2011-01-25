require 'spec_helper'

describe Contact::Press do
  
  describe "valid" do
    subject { Factory(:press) }
    
    its(:email) { should match /email[0-9]+@jilion.com/ }
    its(:state) { should == "new" }
    its(:replied) { should == false }
    its(:issue) { should be_nil }
    its(:message) { should == "A message" }
    it { should_not be_archived }
    it { should be_valid }
    
    it "should be a press" do
      Factory(:press).should be_press
    end
    
  end
  
  describe "invalid" do
    
    it "should validate message presence" do
      Contact::Press.create.errors[:message].should be_present
    end
    
  end
  
  describe "type_name" do
    
    it "should be press" do
      Factory(:press).type_name.should == "press"
    end
    
  end
  
end