# typed: strict

class Contracts::Stories::Show < Dry::Validation::Contract
  params do
    required(:id).filled(:integer)
  end
end
