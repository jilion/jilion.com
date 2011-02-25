require 'spec_helper'

describe Contact do

  describe "valid" do
    subject { Factory(:contact) }

    its(:email)    { should match /email[0-9]+@jilion.com/ }
    its(:state)    { should == "new" }
    its(:replied)  { should == false }
    its(:issue)    { should be_nil }
    its(:filename) { should be_blank }
    its(:file?)    { should be_false }

    it { should be_new }
    it { should be_valid }
  end

  describe "Validations" do
    it { should validate_presence_of(:email) }
    it "should validate email presence" do
      contact = Factory.build(:contact, email: nil)
      contact.should_not be_valid
      contact.errors[:email].should be_present
    end
    it "should validate email length" do
      contact = Factory.build(:contact, email: "1@1.c")
      contact.should_not be_valid
      contact.errors[:email].should be_present
    end
    it "should validate email format" do
      contact = Factory.build(:contact, email: "@google.com")
      contact.should_not be_valid
      contact.errors[:email].should be_present
    end
  end

  describe "#type_name" do
    specify { Factory(:contact).type_name.should == "contact" }
  end

end
