# typed: strict

module StorageService
  extend T::Sig
  extend T::Helpers

  interface!

  sig { abstract.params(text: String).returns(String) }
  def store_text(text); end

  sig { abstract.params(image: String, path: String).returns(String) }
  def store_image(image, path); end

  sig { abstract.params(path: String).returns(T.nilable(String)) }
  def retrieve_image(path); end
end
