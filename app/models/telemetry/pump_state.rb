# Telemetry data sent from a lift station reports the state of the pump (on/off).
# The station reports every two minutes.
# The state of the pump does not necessarily change each time the station reports.
#
# For the sake of the assignment, assume the pump state did not change between reports, rather the
# the pump switched on/off exactly when the telemtry message was sent. (e.g. pump runs for 6 minutes)
class Telemetry::PumpState < ApplicationRecord
  self.table_name = 'pump_states'
  belongs_to :pump

  before_create :evaluate_pump_cycle

  scope :older_than, ->(time) { where('reported_at < ?', time) }

  # TODO: implement method
  # when the pump was off and it switches on, start a PumpCycle
  # when the pump was on and it switches off, end a PumpCycle and include its duration
  def evaluate_pump_cycle
    previous_state = pump.pump_states.older_than(reported_at).last

    if previous_state.nil? || !previous_state.active && active
      pump.pump_cycles.create!(started_at: reported_at)
    elsif previous_state&.active && !active
      last_pump_cycle = pump.pump_cycles.last
      last_pump_cycle.update!(duration: (reported_at - last_pump_cycle.started_at).to_i)
    end
  end
end
