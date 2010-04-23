# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_extensions         = false

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

