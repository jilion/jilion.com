# require 'spec_helper'
# 
# describe Contact::Job do
#   
#   describe "valid" do
#     subject { Factory(:contact_job) }
#     
#     its(:_type) { should == "Contact::Job" }
#     its(:email) { should match /email[0-9]+@jilion.com/ }
#     its(:state) { should == "new" }
#     its(:replied) { should == false }
#     its(:issue) { should be_nil }
#     its(:file_filename) { should == "File" }
#     its(:job_id) { should == "abc123" }
#     it { should_not be_archived }
#     it { should be_valid }
#     
#     it "should be a job" do
#       Factory(:contact_job).should be_job
#     end
#     
#   end
#   
#   describe "invalid" do
#     
#     it "should validate message presence" do
#       Contact::Job.create.errors[:message].should be_present
#     end
#     
#     # it "should validate file presence" do
#     #   Contact::Job.create.errors[:file_filename].should be_present
#     # end
#     
#   end
#   
#   describe "type_name" do
#     
#     it "should be job" do
#       Factory(:contact_job).type_name.should == "job"
#     end
#     
#   end
#   
# end