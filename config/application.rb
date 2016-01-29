require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LucentApi
  class Application < Rails::Application

    ApiPagination.configure do |config|
      config.total_header = 'total'
      config.per_page_header = 'perPage'
      config.page_header = 'page'
    end

    config.active_record.raise_in_transactional_callbacks = true
    config.assets.initialize_on_precompile = false
    Dir[File.join(Rails.root, "app", "extensions", "*.rb")].each { |l| require l }
    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*',
                 :headers => :any,
                 :methods => [:get, :post, :options, :delete, :put, :patch],
                 :expose => ['access-token', 'expiry', 'token-type', 'uid', 'client', 'total', 'perPage', 'page']
      end
    end

  end
end
