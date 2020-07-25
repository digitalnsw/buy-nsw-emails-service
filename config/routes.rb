EmailService::Engine.routes.draw do
  resources :notifications, only: [:create]
end
