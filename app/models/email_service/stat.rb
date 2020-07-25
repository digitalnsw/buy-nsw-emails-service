module EmailService
  class Stat < ApplicationRecord
    self.table_name = 'email_stats'

    scope :search_by_recipient, ->(recipient) { where(recipient: recipient.downcase) }
    scope :with_notification_type, ->(type) { where(notification_type: type) }

    def self.create_stats notification
      return unless notification.notification? && (notification.delivery? || notification.bounce?)
      if notification.bounce?
        notification.bounced_recipients.map do |br|
          EmailService::Stat.create(
            notification_type: 'bounce',
            notification_id: notification.id,
            subject: notification.subject,
            destination: notification.destination,
            sent_to: notification.sent_to,
            sent_at: notification.sent_at,
            notified_at: notification.notified_at,
            recipient: br['emailAddress'].downcase,
            bounce_type: notification.bounce_type,
            bounce_sub_type: notification.bounce_sub_type,
            bounce_diagnostic_code: br['diagnosticCode'],
          ) rescue nil
        end
      else
        notification.delivered_recipients.map do |recipient|
          EmailService::Stat.create(
            notification_type: 'delivery',
            notification_id: notification.id,
            subject: notification.subject,
            destination: notification.destination,
            sent_to: notification.sent_to,
            sent_at: notification.sent_at,
            notified_at: notification.notified_at,
            recipient: recipient.downcase,
          ) rescue nil
        end
      end
    end

    def bounced?
      notification_type == 'bounce'
    end

    def delivered?
      notification_type == 'delivery'
    end
  end
end
