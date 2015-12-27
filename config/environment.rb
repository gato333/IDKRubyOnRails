# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.config.action_mailer.smtp_settings = {
    :address              => ENV["smtp_address"],
    :port                 => ENV["smtp_port"],
    :domain               => ENV["smtp_domain"],
    :user_name            => ENV["default_email"],
    :password             => ENV["default_email_pwd"],
    :authentication       => :plain,
    :enable_starttls_auto => true
}

Rails.application.config.action_mailer.delivery_method = :smtp