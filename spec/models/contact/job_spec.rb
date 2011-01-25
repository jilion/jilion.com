require 'spec_helper'

describe Contact::Job do

  describe "valid" do
    before(:all) { @contact_job = Factory(:contact_job) }
    subject { @contact_job }

    its(:email) { should match /email[0-9]+@jilion.com/ }
    its(:state) { should == "new" }
    its(:replied) { should == false }
    its(:issue) { should be_nil }
    its(:file) { should be_present }
    its(:job_id) { should == "abc123" }
    its(:message) { should == "A message" }
    it { should_not be_archived }
    it { should be_valid }

    it "should be a job" do
      Factory(:contact_job).should be_job
    end

  end
  
  describe "Validations" do
    it "should validate job_id presence" do
      Contact::Job.create(job_id: nil).errors[:job_id].should be_present
    end
  
    it "should validate message presence" do
      Contact::Job.create(message: nil).errors[:message].should be_present
    end
  
    it "should validate file presence" do
      Contact::Job.create(file: nil).errors[:file].should be_present
    end
  end

  describe "type_name" do

    it "should be job" do
      Factory(:contact_job).type_name.should == "job"
    end

  end

end