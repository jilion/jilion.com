# require 'spec_helper'
# 
# describe Contact::Request do
#   
#   describe "valid" do
#     subject { Factory(:request) }
#     
#     its(:_type) { should == "Contact::Request" }
#     its(:email) { should match /email[0-9]+@jilion.com/ }
#     its(:state) { should == "new" }
#     its(:replied) { should == false }
#     its(:issue) { should be_nil }
#     its(:message) { should == "A message" }
#     it { should_not be_archived }
#     it { should be_valid }
#     
#     it "should be a request" do
#       Factory(:request).should be_request
#     end
#     
#   end
#   
#   describe "invalid" do
#     
#     it "should validate message presence" do
#       Contact::Request.create.errors[:message].should be_present
#     end
#     
#   end
#   
#   describe "type_name" do
#     
#     it "should be request" do
#       Factory(:request).type_name.should == "request"
#     end
#     
#   end
#   
# end