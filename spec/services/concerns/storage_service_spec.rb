# typed: false

require "rails_helper"

# Method of utilization

# require the route -- require Rails.root.join('spec/services/concerns/storage_service_spec')
# Then just do it_behaves_like "storage_service"

RSpec.shared_examples "storage_service" do
  it { is_expected.to respond_to(:store_image) }
  it { is_expected.to respond_to(:retrieve_image) }
end
