# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
 
Rails.application.config.assets.precompile += %w( random.js )
 
Rails.application.config.assets.precompile += %w( form.js )

Rails.application.config.assets.precompile += %w( result.js )
 
Rails.application.config.assets.precompile += %w( application.js )

Rails.application.config.assets.precompile += %w( show.js )

Rails.application.config.assets.precompile += %w( googleMaps.js )

Rails.application.config.assets.precompile += %w( edit.js )

Rails.application.config.assets.precompile += %w( social.js )

Rails.application.config.assets.precompile += %w( count.js )

Rails.application.config.assets.precompile += %w( user_event.js )

Rails.application.config.assets.precompile += %w( description.js )
