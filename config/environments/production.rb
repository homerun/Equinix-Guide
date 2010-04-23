# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false
config.action_mailer.raise_delivery_errors = false
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
    :address => "mail.circuitclout.com",
    :port => 26,
    :domain => "tertullian.server0571.info",
    :authentication => :login,
    :user_name => "donotreply+circuitclout.com",
    :password => "5smCz+J7:6F="
}

#config.action_controller.consider_all_requests_local = true  
config.action_controller.consider_all_requests_local = EXCEPTIONS_ON # debugging exception_notifier  
config.action_mailer.raise_delivery_errors = false  
#config.action_mailer.raise_delivery_errors = true # debugging exception_notifier  
