require 'spec_helper'

describe Contact::Job do

  describe "valid" do
    before(:all) { @contact_job = Factory(:contact_job) }
    subject { @contact_job }

    its(:email)   { should match /email[0-9]+@jilion.com/ }
    its(:state)   { should == "new" }
    its(:replied) { should be_false }
    its(:issue)   { should be_nil }
    its(:file)    { should be_present }
    its(:job_id)  { should == "abc123" }
    its(:message) { should == "A message" }

    it { should be_job }
    it { should be_new }
    it { should be_valid }
  end

  describe "Validations" do
    it { should validate_presence_of(:message) }
    it { should validate_presence_of(:file) }
  end

  describe "#type_name" do
    specify { Factory(:contact_job).type_name.should == "job" }
  end

end
