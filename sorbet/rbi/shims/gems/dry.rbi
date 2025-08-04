# typed: strict

class Dry::Validation::Contract
  extend T::Sig

  sig { params(external_schemas: T.untyped, block: T.proc.void).returns(T.untyped) }
  def self.params(*external_schemas, &block); end

  sig { params(keys: T.untyped, block: T.proc.void).returns(T.untyped) }
  def self.rule(*keys, &block); end

  sig { params(key: Symbol).returns(T.untyped) }
  def self.required(key); end

  sig { params(key: Symbol).returns(T.untyped) }
  def self.optional(key); end

  sig { returns(T.untyped) }
  def self.key; end

  sig { returns(T.untyped) }
  def self.value; end

  sig { returns(T.untyped) }
  def self.values; end
end
