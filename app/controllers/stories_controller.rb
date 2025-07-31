# typed: strict

class StoriesController < ApplicationController
  extend T::Sig

  sig { void }
  def create
    CreateStoryJob.perform_later(params[:prompt])
    render json: { message: "Story creation started" }, status: :accepted
  end
end