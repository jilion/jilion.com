require 'spec_helper'

describe Job do
  
  describe "valid" do
    subject { Factory(:job) }
    
    its(:title)       { should == "Fluent english writer" }
    its(:description) { should == "Job description" }
    its(:state)       { should == 'new' }
    
    it { should_not be_archived }
    it { should be_valid }
  end
  
  describe "invalid" do
    
    it "should validate title presence" do
      job = Factory(:job, :title => nil)
      job.should_not be_valid
      job.errors[:title].should be_present
      
      job = Factory(:job, :title => '')
      job.should_not be_valid
      job.errors[:title].should be_present
    end
    
    it "should validate description presence" do
      job = Factory(:job, :description => nil)
      job.should_not be_valid
      job.errors[:description].should be_present
      
      job = Factory(:job, :description => '')
      job.should_not be_valid
      job.errors[:description].should be_present
    end
    
    it "should have 'new' state when created" do
      Factory(:job).state.should == "new"
    end
    
  end
  
end