# Be sure to restart your server when you modify this file.

# Propshaft handles CSS/images automatically - no configuration needed here
# JavaScript is handled by importmap, not the asset pipeline

# Prevent Sprockets from complaining about JavaScript files in production
# (they're handled by importmap, not the asset pipeline)
if defined?(Sprockets) &&
   Rails.application.config.respond_to?(:assets) &&
   Rails.application.config.assets.respond_to?(:precompile)
  # Add all JavaScript files that importmap might reference
  # These are placeholders so Sprockets is satisfied; importmap serves them
  Rails.application.config.assets.precompile += %w[
    application.js
    controllers/application.js
    controllers/hello_controller.js
    controllers/index.js
    controllers/modal_controller.js
  ]
end
