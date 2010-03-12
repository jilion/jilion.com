require 'spec_helper'

describe Contact::TeamUp do
  
  describe "valid" do
    subject { Factory(:team_up) }
    
    its(:_type) { should == "Contact::TeamUp" }
    its(:email) { should match /email[0-9]+@jilion.com/ }
    its(:state) { should == "new" }
    its(:replied) { should == false }
    its(:issue) { should be_nil }
    its(:message) { should == "A message" }
    it { should_not be_archived }
    it { should be_valid }
    
    it "should be a team_up" do
      Factory(:team_up).should be_team_up
    end
    
  end
  
  describe "invalid" do
    
    it "should validate message presence" do
      Contact::TeamUp.create.errors[:message].should be_present
    end
    
  end
  
  describe "type_name" do
    
    it "should be team_up" do
      Factory(:team_up).type_name.should == "team_up"
    end
    
  end
  
end