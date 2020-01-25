module StatusLogger
  module ActsAsStatusLogger
    extend ActiveSupport::Concern

    included do
      has_many :status_logs,
               as: :status_loggeable,
               dependent: :destroy

      after_save :save_logs

      protected

        def save_logs
          BusinessTime::Config.beginning_of_workday = '8:00 am'
          BusinessTime::Config.end_of_workday = '8:00 pm'

          status_attributes.each do |status_attr|

            status_attr = status_attr.to_s

            return unless self.send("#{status_attr}_previously_changed?")

            keys = self.class.name.constantize.send("#{status_attr.pluralize}")

            previous_change = self.send("#{status_attr}_previous_change")

            from = keys[previous_change.first]
            to = keys[previous_change.last]

            last_status_log = self.status_logs.last

            started_at = if last_status_log.present?
                           last_status_log.ended_at
                         else
                           self.created_at
                         end

            ended_at = Time.current

            elapsed_time = ended_at - started_at.to_time

            elapsed_business_time = started_at.business_time_until(ended_at)
                                              .to_i

            self.status_logs
                .create(status_attribute: status_attr,
                        from: from,
                        to: to,
                        started_at: started_at,
                        ended_at: ended_at,
                        elapsed_time: elapsed_time,
                        elapsed_business_time: elapsed_business_time)
          end
        end
    end

    module ClassMethods
      def acts_as_status_logger(options = {})
        cattr_accessor :status_attributes, instance_writer: false
        self.status_attributes = options[:status_attributes]
      end
    end
  end
end