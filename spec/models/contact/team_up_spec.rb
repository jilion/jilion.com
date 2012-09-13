require 'spec_helper'

describe Contact::TeamUp do

  describe "valid" do
    subject { build(:team_up) }

    its(:email) { should match /email[0-9]+@jilion.com/ }
    its(:state) { should == "new" }
    its(:replied) { should be_false }
    its(:issue) { should be_nil }
    its(:message) { should == "A message" }

    it { should be_team_up }
    it { should be_valid }
  end

  describe "Validations" do
    it { should validate_presence_of(:message) }
  end

  describe "#type_name" do
    specify { create(:team_up).type_name.should == "team_up" }
  end

end
