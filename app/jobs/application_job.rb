class ApplicationJob < ActiveJob::Base
  extend T::Sig

  include Sidekiq::Job
  queue_as :default
  sidekiq_options retry: false
end
