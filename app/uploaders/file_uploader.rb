# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base

  # Override the directory where uploaded files will be stored
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def s3_bucket
    S3Bucket.bucket
  end

  # Override the directory where uploaded files will be stored
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    case Rails.env
    when 'production', 'staging'
      "files"
    else
      "uploads/files"
    end
  end

end
