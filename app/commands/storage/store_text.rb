# typed: strict

class Storage::StoreText < Command
  extend T::Sig

  sig { params(text: String).void }
  def initialize(text:)
    @text = text
    @storage_service = T.let(nil, T.nilable(StorageService))
  end

  private

  sig { returns(String) }
  def execute
    Rails.logger.info("Storing text")
    text_path = storage_service.store_text(@text)
    Rails.logger.info("Text stored in path #{text_path}")
    text_path
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
end
