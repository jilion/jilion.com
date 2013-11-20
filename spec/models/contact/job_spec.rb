require 'spec_helper'

describe Contact::Job do

  describe 'valid' do
    subject { create(:contact_job) }

    its(:email)   { should match /email[0-9]+@jilion.com/ }
    its(:state)   { should eq 'new' }
    its(:replied) { should be_false }
    its(:issue)   { should be_present }
    its(:file)    { should be_present }
    its(:job)     { should be_a(Job)  }
    its(:message) { should eq 'A message' }

    it { should be_valid }
  end

  describe 'Validations' do
    it { should validate_presence_of(:message) }
    it { should validate_presence_of(:file) }
  end

  describe '#type_name' do
    specify { create(:contact_job).type_name.should eq 'job' }
  end

end
