# typed: strict

class CreateStoryJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  sig { params(prompt: String).void }
  def perform(prompt)
    Rails.logger.info("Creating story with prompt: #{prompt}")
  end
end
