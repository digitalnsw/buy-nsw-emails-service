module EmailService
  class Notification < ApplicationRecord
    self.table_name = 'email_notifications'

    after_create :create_stats

    def create_stats
      EmailService::Stat.create_stats self
    end

    def notification?
      body['Type'] == "Notification" && message.is_a?(Hash) rescue nil
    end

    def message
      return @message if @message == false
      @message ||= (JSON.parse body['Message'] rescue false)
    end

    def bounce?
      message && message['notificationType'] == 'Bounce' rescue nil
    end

    def delivery?
      message && message['notificationType'] == 'Delivery' rescue nil
    end

    def bounce
      message && message['bounce'] rescue nil
    end

    def delivery
      message && message['delivery'] rescue nil
    end

    def mail
      message && message['mail'] rescue nil
    end

    def destination
      mail && mail['destination'] rescue nil
    end

    def headers
      mail && mail['headers'] rescue nil
    end

    def common_headers
      mail && mail['commonHeaders'] rescue nil
    end

    def get_header key
      headers && headers.is_array? && headers.find{|r| r['name'].downcase == key.downcase}['value'] rescue nil
    end

    def subject
      common_headers && common_headers['subject'] || get_header('Subject') rescue nil
    end

    def timestamp
      DateTime.parse(mail['timestamp']) rescue nil
    end

    def sent_at
      DateTime.parse(common_headers['date'] || get_header['Date']) rescue nil
    end

    def sent_to
      common_headers['to'] rescue nil
    end

    def delivered_at
      DateTime.parse(delivery['timestamp']) rescue nil
    end

    def delivered_recipients
      delivery['recipients'] rescue nil
    end

    def bounced_at
      DateTime.parse(bounce['timestamp']) rescue nil
    end

    def bounced_recipients
      bounce['bouncedRecipients'] rescue nil
    end

    def bounced_addresses
      bounced_recipients.map{|r| r['emailAddress']} rescue nil
    end

    def bounced_codes
      bounced_recipients.map{|r| r['diagnosticCode']} rescue nil
    end

    def bounce_type
      bounce && bounce['bounceType'] rescue nil
    end

    def bounce_sub_type
      bounce && bounce['bounceSubType'] rescue nil
    end

    def notified_at
      delivered_at || bounced_at
    end
  end
end
