# typed: strict

class Storage::ProductionService
  extend T::Sig
  include StorageService

  sig { override.params(text: String).returns(String) }
  def store_text(text)
    raise "Not implemented"
  end

  sig { override.params(image: String, path: String).returns(String) }
  def store_image(image, path)
    raise "Not implemented"
  end

  sig { override.params(path: String).returns(T.nilable(String)) }
  def retrieve_image(path)
    raise "Not implemented"
  end
end
