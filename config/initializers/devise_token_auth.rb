DeviseTokenAuth.setup do |config|
  config.token_lifespan = 3.days
  config.default_confirm_success_url = "http://locent.helloworld.ng/#/dashboard"
end
