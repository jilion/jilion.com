# require 'spec_helper'
# 
# describe Contact::Deal do
#   
#   describe "valid" do
#     subject { Factory(:deal) }
#     
#     its(:_type) { should == "Contact::Deal" }
#     its(:email) { should match /email[0-9]+@jilion.com/ }
#     its(:state) { should == "new" }
#     its(:replied) { should == false }
#     its(:issue) { should be_nil }
#     its(:exclusive_request) { should be_true }
#     its(:exclusive_request_business_days) { should == 20 }
#     its(:name) { should == "Steve Jobs" }
#     its(:phone) { should == "+41 76 400 5101" }
#     its(:organization) { should == "Apple" }
#     its(:url) { should == "http://apple.com" }
#     its(:activity) { should == "Computer Manufacturer" }
#     its(:budget) { should == "$1,000,000" }
#     its(:project_description) { should == "The iPad secret project" }
#     its(:goal) { should == "Be the best" }
#     its(:metrics) { should == "What a metric" }
#     its(:challenge) { should == "Huge challenge" }
#     its(:deadline) { should == "1st of April" }
#     its(:comment) { should == "No comment" }
#     its(:filename) { should be_blank }
#     its(:file?) { should be_false }
#     it { should_not be_archived }
#     it { should be_valid }
#     
#     it "should be a deal" do
#       Factory(:deal).should be_deal
#     end
#     
#   end
#   
#   describe "invalid" do
#     
#     it "should set exclusive_request_business_days to nil" do
#       Factory(:deal, :exclusive_request => false).exclusive_request_business_days.should be_nil
#     end
#     
#     it "should validate name presence" do
#       Contact::Deal.create.errors[:name].should be_present
#     end
#     
#     it "should validate activity presence" do
#       Contact::Deal.create.errors[:activity].should be_present
#     end
#     
#     it "should validate budget presence" do
#       Contact::Deal.create.errors[:budget].should be_present
#     end
#     
#     it "should validate project_description presence" do
#       Contact::Deal.create.errors[:project_description].should be_present
#     end
#     
#   end
#   
#   describe "type_name" do
#     
#     it "should be deal" do
#       Factory(:deal).type_name.should == "deal"
#     end
#     
#   end
#   
# end