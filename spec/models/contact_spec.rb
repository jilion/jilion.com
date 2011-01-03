# require 'spec_helper'
# 
# describe Contact do
#   
#   describe "valid" do
#     subject { Factory(:contact) }
#     
#     its(:_type) { should == "Contact" }
#     its(:email) { should match /email[0-9]+@jilion.com/ }
#     its(:state) { should == "new" }
#     its(:replied) { should == false }
#     its(:issue) { should be_nil }
#     its(:filename) { should be_blank }
#     its(:file?) { should be_false }
#     it { should_not be_archived }
#     it { should be_valid }
#   end
#   
#   describe "invalid" do
#     
#     it "should validate email presence" do
#       Contact.create.errors[:email].should be_present
#     end
#     
#     it "should validate email length" do
#       Contact.create(:email => "1@1.c").errors[:email].should be_present
#     end
#     
#     it "should validate email format" do
#       Contact.create(:email => "@google.com").errors[:email].should be_present
#     end
#     
#     it "should have 'new' state when created" do
#       Contact.create(:email => "bob@bob.com").state.should == "new"
#     end
#     
#   end
#   
#   describe "type_name" do
#     
#     it "should be contact" do
#       Factory(:contact).type_name.should == "contact"
#     end
#     
#   end
#   
# end