# typed: strict

class StoriesController < ApplicationController
  extend T::Sig

  before_action :validate_create_story_params, only: [ :create_story ]
  before_action :validate_get_story_params, only: [ :get_story ]

  sig { void }
  def create_story
    CreateStoryJob.perform_later(params[:story_prompt], params[:drawing_style])
    render json: { message: "Story creation started" }, status: :accepted
  end

  sig { void }
  def get_stories
    stories = Story.all.order(created_at: :desc)
    render json: { stories: stories }, status: :ok
  end

  sig { void }
  def get_story
    story = Story.find_by(id: params[:id])
    if story.nil?
      render json: { error: "Story not found" }, status: :not_found
    else
      render json: { story: story }, status: :ok
    end
  end

  private

  sig { void }
  def validate_create_story_params
    result = create_story_contract

    unless result.success?
      render json: { errors: result.errors.to_h }, status: :unprocessable_entity
    end
  end

  sig { returns(Dry::Validation::Result) }
  def create_story_contract
    @create_story_contract ||= T.let(
      Contracts::Stories::Create.new.call(params.permit(:story_prompt, :drawing_style).to_h),
      T.nilable(Dry::Validation::Result)
    )
  end

  sig { returns(Dry::Validation::Result) }
  def get_story_contract
    @get_story_contract ||= T.let(
      Contracts::Stories::Show.new.call(params.permit(:id).to_h),
      T.nilable(Dry::Validation::Result)
    )
  end

  sig { void }
  def validate_get_story_params
    result = get_story_contract

    unless result.success?
      render json: { errors: result.errors.to_h }, status: :unprocessable_entity
    end
  end
end
