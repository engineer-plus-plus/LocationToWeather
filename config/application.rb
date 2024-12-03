require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LocationToWeather
  class Application < Rails::Application
    config.cache_store = :redis_store, "redis://localhost:6379/0/cache", { expires_in: 30.minutes }    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1



    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # Redis caching configuration
    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 30.minutes }    
  end
end

   

    # Suppress Ruby 2.7 warnings
    require 'warning'
    Warning.ignore(/already initialized constant/)
    Warning.ignore(/Using the last argument as keyword parameters is deprecated/)
