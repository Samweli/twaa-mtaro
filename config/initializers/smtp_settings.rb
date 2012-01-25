ActionMailer::Base.smtp_settings = {
  #:address        => "smtp.sendgrid.net",
  :address        => "webappsmail.cityofchicago.org",
  :port           => 25,
  #:authentication => :plain,
  #:user_name      => ENV['SENDGRID_USERNAME'],
  #:password       => ENV['SENDGRID_PASSWORD'],
  #:domain         => ENV['SENDGRID_DOMAIN']

  #:user_name      => ENV['MAILER_CS_USERNAME'] || '',
  #:password       => ENV['MAILER_CS_PASSWORD'] || '',
  #:domain         => ENV['MAILER_CS_DOMAIN'] || ''
}
