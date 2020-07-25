Rails.application.routes.draw do
  mount EmailService::Engine => "/email_service"
end
