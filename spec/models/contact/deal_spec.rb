require 'spec_helper'

describe Contact::Deal do
  
  it "should be valid" do
    deal = Contact::Deal.new(:email => "bob@bob.com", :budget => "10000")
    deal.should be_valid
  end
  
  it "should be a deal" do
    deal = Contact::Deal.new(:email => "bob@bob.com", :budget => "10000")
    deal.should be_deal
  end
  
  it "should validate budget presence" do
    deal = Contact::Deal.create(:email => "bob@bob.com")
    deal.errors[:budget].should be_present
  end
  
end