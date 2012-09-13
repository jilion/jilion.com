require 'spec_helper'

describe Contact::Press do

  describe "valid" do
    subject { build(:press) }

    its(:email)   { should match /email[0-9]+@jilion.com/ }
    its(:state)   { should == "new" }
    its(:replied) { should be_false }
    its(:issue)   { should be_nil }
    its(:message) { should == "A message" }

    it { should be_press }
    it { should be_valid }
  end

  describe "Validations" do
    it { should validate_presence_of(:message) }
  end

  describe "#type_name" do
    specify { create(:press).type_name.should == "press" }
  end

end
