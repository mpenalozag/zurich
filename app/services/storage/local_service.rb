# typed: strict

class Storage::LocalService
  extend T::Sig
  include StorageService

  BASE_FOLDER = 'tmp'
  IMAGE_FOLDER = 'images'

  sig { override.params(image: String, path: String).returns(String) }
  def store_image(image, path)
    timestamp = Time.current.strftime("%Y%m%d_%H%M%S_%L")
    filename = "#{path}#{timestamp}.jpeg"
    file_path = Rails.root.join(BASE_FOLDER, IMAGE_FOLDER, filename)

    FileUtils.mkdir_p(File.dirname(file_path))
    File.open(file_path, "wb") do |file|
      file.write(image)
    end

    file_path.to_s
  end

  sig { override.params(path: String).returns(T.nilable(String)) }
  def retrieve_image(path)
    nil
  end
end
