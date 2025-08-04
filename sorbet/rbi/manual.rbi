# typed: strong

# Manual type definitions for constants not captured by Tapioca
module Sidekiq
  class Web
  end
end

# ActiveJob gets Sidekiq methods when using Sidekiq adapter
class ActiveJob::Base
  sig { params(opts: T::Hash[Symbol, T.untyped]).void }
  def self.sidekiq_options(opts = {}); end
end
