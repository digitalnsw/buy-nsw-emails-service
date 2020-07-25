module EmailService
  class Engine < ::Rails::Engine
    isolate_namespace EmailService
    config.generators.api_only = true
  end
end
