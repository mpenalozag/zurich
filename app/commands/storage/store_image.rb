# typed: strict

class Storage::StoreImage < Command
  extend T::Sig

  sig { params(image_data: String, path: String, data_type: String).void }
  def initialize(image_data:, path:, data_type:)
    @image_data = image_data
    @path = path
    @data_type = data_type
    @storage_service = T.let(nil, T.nilable(StorageService))
  end

  private

  sig { returns(String) }
  def execute
    raise "Data type #{@data_type} not supported" unless @data_type == "base64"

    Rails.logger.info("Storing image in path #{@path}")
    binary_image = binary_image_from_base64(@image_data)
    image_path = storage_service.store_image(binary_image, @path)
    image_path
  end

  sig { returns(StorageService) }
  def storage_service
    case Rails.env
    when "development"
      @storage_service ||= Storage::LocalService.new
    when "production"
      @storage_service ||= Storage::ProductionService.new
    else
      raise "Invalid environment for storage service: #{Rails.env}"
    end
  end

  sig { params(data: String).returns(String) }
  def binary_image_from_base64(data)
    binary_data = Base64.decode64(data)
  end
end
