class StatusLog < ActiveRecord::Base
  belongs_to :status_loggeable, polymorphic: true

  validates :status_loggeable_id, :status_loggeable, :status_attribute, :to,
            :started_at, :ended_at, :elapsed_time, :elapsed_business_time,
            presence: true
end