# represents a cycle in which the pump ran
# pump turns on => cycle starts
# pump turns off => cycle ends
class PumpCycle < ApplicationRecord
  belongs_to :pump

  scope :for_pump, ->(pump) { where(pump:) }
  scope :unfinished, -> { where(duration: nil).where.not(started_at: nil) }

  # cycle has completed
  def ended?
    duration.present?
  end

  # datetime that cycle ended
  def ended_at
    started_at + duration.seconds
  end

  # create new LiftStationCycle with estimations
  def calculate_lift_station_cycle
    LiftStationFlowEstimator.new(lift_station: pump.lift_station).perform
  end
end
