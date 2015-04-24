require File.expand_path('../boot', __FILE__)

require 'rails/all'


Bundler.require(*Rails.groups)

module UrbanOutdoor
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
    config.generators do |g|
      g.test_framework :rspec, view_specs: false, helper_specs: true, fixture: true
      g.fixture_replacement :factory_girl, dir: "spec/support/factories"
    end
  end
end
