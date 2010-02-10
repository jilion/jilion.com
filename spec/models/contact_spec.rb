require 'spec_helper'

describe Contact do
  
  it "should be valid" do
    contact = Contact.new(:email => "bob@bob.com")
    contact.should be_valid
  end
  
  it "should validate email presence" do
    contact = Contact.create
    contact.errors[:email].should be_present
  end
  
  it "should validate email length" do
    contact = Contact.create(:email => "1@1.c")
    contact.errors[:email].should be_present
  end
  
  it "should validate email format" do
    contact = Contact.create(:email => "@google.com")
    contact.errors[:email].should be_present
  end
  
  it "should have 'new' state when created" do
    contact = Contact.create(:email => "@google.com")
    contact.state.should == "new"
  end
  
end