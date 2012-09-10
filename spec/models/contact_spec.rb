require 'spec_helper'

describe Contact do

  describe "valid" do
    subject { build(:contact) }

    its(:email)      { should match /email[0-9]+@jilion.com/ }
    its(:state)      { should == "new" }
    its(:replied_at) { should be_nil }
    its(:issue)      { should be_nil }
    its(:filename)   { should be_blank }
    its(:file?)      { should be_false }

    it { should_not be_replied }
    it { should_not be_archived }
    it { should_not be_trashed }
    it { should be_valid }
  end

  describe "Validations" do
    it { should validate_presence_of(:email) }
    it "should validate email presence" do
      contact = build(:contact, email: nil)
      contact.should_not be_valid
      contact.errors[:email].should be_present
    end
    it "should validate email length" do
      contact = build(:contact, email: "1@1.c")
      contact.should_not be_valid
      contact.errors[:email].should be_present
    end
    it "should validate email format" do
      contact = build(:contact, email: "@google.com")
      contact.should_not be_valid
      contact.errors[:email].should be_present
    end
  end

  describe "#replied=" do
    specify { create(:contact, replied: '1').replied_at.should be_present }
  end

  describe "#replied?" do
    specify { create(:contact, replied: '1').should be_replied }
  end

  describe "#type_name" do
    specify { create(:contact).type_name.should == "contact" }
  end

  describe "#after_create" do
    specify { expect { build(:contact) }.to_not change(ActionMailer::Base.deliveries, :count) }
    specify { expect { create(:contact) }.to change(ActionMailer::Base.deliveries, :count).by(1) }
  end

end
