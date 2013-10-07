require 'spec_helper'
require 'fog'
require 'config/carrierwave'

require 'file_uploader'

describe FileUploader do
  let(:contact_created_before_oct_7_2013) { create(:contact, created_at: Time.utc(2013, 10, 7, 12, 30)) }
  let(:contact_created_after_oct_7_2013) { create(:contact, created_at: Time.utc(2013, 10, 7, 12, 31)) }
  let(:resume) { fixture_file('resume.txt') }
  let(:uploader) { described_class.new(contact_created_after_oct_7_2013, :file) }

  before { Rails.stub(:env) { double('test', to_s: 'test', test?: true) } }
  before { uploader.store!(resume) }

  pending 'has stats_exports S3.bucket' do
    uploader.fog_directory.should eq ENV['S3_BUCKET']
  end

  pending 'is private' do
    uploader.fog_public.should be_false
  end

  context 'file uploaded before Time.utc(2013, 10, 7, 10, 25)' do
    let(:uploader) { described_class.new(contact_created_before_oct_7_2013, :file) }

    it 'has right non-unique path' do
      uploader.file.path.should match %r{uploads/files/#{uploader.filename}$}
    end
  end

  context 'file uploaded after Time.utc(2013, 10, 7, 10, 26)' do
    let(:uploader) { described_class.new(contact_created_after_oct_7_2013, :file) }

    it 'has right unique path' do
      uploader.file.path.should match %r{uploads/files/#{contact_created_after_oct_7_2013.class.to_s.underscore}/file/#{contact_created_after_oct_7_2013.id}/#{uploader.filename}$}
    end
  end

  it 'has good filename' do
    uploader.filename.should eq 'resume.txt'
  end

end
