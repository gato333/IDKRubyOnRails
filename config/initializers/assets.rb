# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( noscript.css )

Rails.application.config.assets.precompile += %w( style.css )

Rails.application.config.assets.precompile += %w( style-desktop.css )

Rails.application.config.assets.precompile += %w( skel-noscript.css )

Rails.application.config.assets.precompile += %w( init.js )

Rails.application.config.assets.precompile += %w( skel.min.js )

Rails.application.config.assets.precompile += %w( jquery.min.js )
