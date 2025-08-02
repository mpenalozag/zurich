# typed: strict

class CreateStoryJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  sig { params(story_prompt: String, drawing_style: String).void }
  def perform(story_prompt, drawing_style)
    Stories::CreateStory.new(story_prompt, drawing_style).run
  end
end
