# typed: strict

class Contracts::Stories::Create < Dry::Validation::Contract
  params do
    required(:story_prompt).filled(:string)
    required(:drawing_style).filled(:string)
  end
end
