# Action Cable configuration
Rails.application.configure do
  # Allow Action Cable requests from any origin in development
  if Rails.env.development?
    config.action_cable.allowed_request_origins = [
      /http:\/\/localhost*/,
      /http:\/\/127\.0\.0\.1*/,
      /http:\/\/0\.0\.0\.0*/
    ]
  end
end
