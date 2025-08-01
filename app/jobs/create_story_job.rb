# typed: strict

class CreateStoryJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  sig { params(prompt: String).void }
  def perform(prompt)
    Stories::CreateStory.new(prompt).run
  end
end
