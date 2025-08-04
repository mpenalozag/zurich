# typed: false

Dry::Validation::Rails.configure do |config|
  config.default_schema_prefix = "ApplicationContract::"
  config.default_schema_suffix = "Schema"
end

# Alternative configuration approach (commented out due to conflicting suffix)
# Dry::Validation::Rails.configuration.default_schema_prefix = 'ApplicationContract::'
# Dry::Validation::Rails.configuration.default_schema_suffix = 'Contract'
