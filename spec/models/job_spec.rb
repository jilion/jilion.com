require 'spec_helper'

describe Job do

  describe "valid" do
    subject { create(:job) }

    its(:title)       { should == "Fluent english writer" }
    its(:summary)     { should == "Job summary" }
    its(:description) { should == "Job description" }
    its(:state)       { should == 'new' }

    it { should be_is_new }
    it { should be_valid }
  end

  describe "Validations" do
    subject { create(:job) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

end
