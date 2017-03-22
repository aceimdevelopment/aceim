# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Aceim::Application.initialize!


ActionMailer::Base.smtp_settings = {
  :user_name => 'aceim',
  :password => 'aceimaceim123',
  :domain => 'sendgrid.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
