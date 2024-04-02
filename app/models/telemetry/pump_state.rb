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
    return pump.pump_cycles.create(started_at: reported_at) if pump_was_off_and_switch_is_on?

    if pump_was_on_and_switch_is_off?
      last_pump_cycle = pump.pump_cycles.last
      last_pump_cycle.update(duration: (reported_at - last_pump_cycle.started_at).to_i)
    end
  end

  private

  def recent_previous_pump_state
    pump.pump_states.older_than(Time.current).last
  end

  def pump_was_off_and_switch_is_on?
    recent_previous_pump_state.blank? || (!recent_previous_pump_state.active && active)
  end

  def pump_was_on_and_switch_is_off?
    recent_previous_pump_state.active && !active
  end
end
