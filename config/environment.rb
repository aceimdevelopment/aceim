# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Aceim::Application.initialize!


#ActionMailer::Base.smtp_settings = {
#  :user_name => 'aceim',
#  :password => 'aceimaceim123',
#  :domain => 'sendgrid.com',
#  :address => 'smtp.sendgrid.net',
#  :port => 587,
#  :authentication => :plain,
#  :enable_starttls_auto => true
#}


# ActionMailer::Base.delivery_method = :smtp
# ActionMailer::Base.smtp_settings = {
#   :authentication => :plain,
#   :address => "smtp.mailgun.org",
#   :port => 587,
#   :domain => "sandbox610c8f4cb85a4a1fbfbfe9bb2be82900.mailgun.org",
#   :user_name => "postmaster@sandbox610c8f4cb85a4a1fbfbfe9bb2be82900.mailgun.org",
#   :password => "key-fa31682342a1c189e54204b6bf46c776"
# }