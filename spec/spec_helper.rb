# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment",  __FILE__)
require 'rspec/rails'
# require 'sidekiq/testing'
#
# Sidekiq::Testing.fake!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.before(:each) do
    # Sidekiq::Worker.clear_all
    if Rails.application.secrets.herd_s3_enabled
      
      AWS.config({
        access_key_id:     ENV['HERD_TESTING_AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['HERD_TESTING_AWS_SECRET_ACCESS_KEY'],
        http_open_timeout: 30, 
        http_read_timeout: 120
      })

      bucket = AWS::S3.new.buckets[Rails.application.secrets.herd_s3_bucket]
      bucket.objects.with_prefix(Rails.application.secrets.herd_s3_path_prefix).delete_all
    else
      FileUtils.rm_rf File.join(Rails.root, 'public', 'uploads')
    end
  end
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  
  config.fixture_path = "#{Herd::Engine.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end
