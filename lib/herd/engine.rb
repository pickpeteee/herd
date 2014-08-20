require 'haml-rails'
require 'ember-rails'
require 'ember_script-rails'
require 'emblem/rails'
require 'jquery-rails'
require 'jquery-ui-rails'

require 'active_model_serializers'
require 'filemagic'
require 'mini_magick'
require 'exifr'
require 'sidekiq'
require 'streamio-ffmpeg'
require 'progressbar'
require 'open-uri'
require 'zip'
require 'sidekiq'
require 'sidekiq-status'
require 'rb-fsevent'

module Herd
  class Engine < ::Rails::Engine
    isolate_namespace Herd

    config.generators do |g|
      g.test_framework :rspec
      g.template_engine :haml
    end

    initializer "add herd to precompile", :group => :all do |app|
      app.config.assets.precompile += %w(
        application.css
        application.js
        core.js
        namespace.js
      )
    end

    initializer 'activeservice.autoload', :before => :set_autoload_paths do |app|
      app.config.eager_load_paths << "#{config.root}/app/workers"
      app.config.eager_load_paths << "#{config.root}/lib"
    end

    initializer :append_herd_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    # initializer :setup_sidekiq_middlewares do |app|
    #   Sidekiq.configure_client do |config|
    #     config.client_middleware do |chain|
    #       chain.add Sidekiq::Status::ClientMiddleware
    #     end
    #   end
    #
    #   Sidekiq.configure_server do |config|
    #     config.server_middleware do |chain|
    #       chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes # default
    #     end
    #     config.client_middleware do |chain|
    #       chain.add Sidekiq::Status::ClientMiddleware
    #     end
    #   end
    # end

  end
end
