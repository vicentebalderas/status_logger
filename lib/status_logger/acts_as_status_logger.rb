module StatusLogger
  module ActsAsStatusLogger
    extend ActiveSupport::Concern

    included do
      after_save :save_status_changes

      protected

        def save_status_changes
          BusinessTime::Config.beginning_of_workday = '8:00 am'
          BusinessTime::Config.end_of_workday = '7:00 pm'

          binding.pry

          to = 'pending'

          last_status_log = self.status_logs.last

          if last_status_log.present?
            from = last_status_log.to
            started_at = last_status_log.transition_ended_at
          else
            from = nil
            started_at = self.created_at
          end

          ended_at = Time.current

          elapsed_time = started_at.to_time - ended_at

          elapsed_business_time = started_at
                                    .business_time_until(transition_ended_at)
                                    .to_i

          self.status_logs
              .create(status_attribute: 'status',
                      from: from,
                      to: to,
                      started_at: started_at,
                      ended_at: ended_at,
                      elapsed_time: elapsed_time,
                      elapsed_business_time: elapsed_business_time)
        end
    end

    class_methods do
      def acts_as_status_logger(options = {})
        @status_attributes = options[:status_attributes]
      end
    end
  end
end

# class StatusChangeLog < ApplicationRecord
#   belongs_to :status_loggeable, polymorphic: true
# end

# class JobApplication < ApplicationRecord
#   has_many :status_change_logs, as: :status_loggeable
# end