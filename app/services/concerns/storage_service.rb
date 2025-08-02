# typed: strict

module StorageService
  extend T::Sig
  extend T::Helpers
  
  interface!

  sig { abstract.returns(T::Boolean) }
  def store_image; end

  sig { abstract.returns(T.nilable(String)) }
  def retrieve_image; end
end
