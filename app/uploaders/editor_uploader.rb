# encoding: utf-8

class EditorUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  include CarrierWave::RMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  storage :file
  #storage :grid_fs
  # storage :s3

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    #"/images/fallback/" + [version_name, "default.png"].compact.join('_')
    "/images/small_missing.png"
  end
  
  # Process files as they are uploaded:
  process :resize_to_fit => [1920, 1080]
  process :quality => 100
  #process :convert => 'jpg'
  
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :icon do
    process :resize_to_fill => [80, 80]
    process :quality => 100
    #process :convert => 'jpg'
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # def filename
  #   "something.jpg" if original_filename
  # end

  process :save_file_size
  process :save_content_type
  
  def save_file_size
    model.asset_filesize = file.size
  end
  
  def save_content_type
    model.asset_contenttype = file.content_type
  end
end
