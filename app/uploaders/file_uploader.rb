# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base

  # Override the directory where uploaded files will be stored
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    dir = if model.created_at > Time.utc(2013, 10, 7, 10, 25)
      "files/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      'files'
    end
    dir = "uploads/#{dir}" unless %w[production staging].include?(Rails.env)

    dir
  end

end
