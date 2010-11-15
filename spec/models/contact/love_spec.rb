# require 'spec_helper'
# 
# describe Contact::Love do
#   
#   describe "valid" do
#     subject { Factory(:love) }
#     
#     its(:_type) { should == "Contact::Love" }
#     its(:email) { should match /email[0-9]+@jilion.com/ }
#     its(:state) { should == "new" }
#     its(:replied) { should == false }
#     its(:issue) { should be_nil }
#     its(:message) { should == "A message" }
#     it { should_not be_archived }
#     it { should be_valid }
#     
#     it "should be a love" do
#       Factory(:love).should be_love
#     end
#     
#   end
#   
#   describe "invalid" do
#     
#     it "should validate message presence" do
#       Contact::Love.create.errors[:message].should be_present
#     end
#     
#   end
#   
#   describe "type_name" do
#     
#     it "should be love" do
#       Factory(:love).type_name.should == "love"
#     end
#     
#   end
#   
# end