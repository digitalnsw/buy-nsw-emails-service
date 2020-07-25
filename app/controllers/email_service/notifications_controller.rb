require_dependency "email_service/application_controller"
require 'json'

module EmailService
  class NotificationsController < EmailService::ApplicationController
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    skip_before_action :verify_authenticity_token, raise: false, only: [:create]

    def create
      noti = EmailService::Notification.create!(body: JSON.parse(request.raw_post))
      render json: { id: noti.id }
    end
  end
end
