require 'spec_helper'

describe Job do

  describe "valid" do
    subject { Factory(:job) }

    its(:title)       { should == "Fluent english writer" }
    its(:summary)     { should == "Job summary" }
    its(:description) { should == "Job description" }
    its(:state)       { should == 'new' }

    it { should be_new }
    it { should be_valid }
  end

  describe "Validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:summary) }
    it { should validate_presence_of(:description) }
  end

end
