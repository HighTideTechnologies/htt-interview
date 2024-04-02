# calculates estimates for the
#  -inflow rate
#  - flow rate
#  - flow total
# and creates a new LiftStationCycle to record the data
class LiftStationFlowEstimator
  def initialize(lift_station:)
    @lift_station = lift_station
    @recent_pump_cycle = lift_station.pump_cycles.last
    @recent_pump_state = lift_station.pump.pump_states.last
  end

  # calculate the values and create a new LiftStationCycle to record
  def perform
    LiftStationCycle.create(inflow_rate:, outflow_rate:, flow_total:, lift_station: @lift_station)
  end

  # represents the rate of liquid flow into a lift station tank
  # may be calculated as: 
  # volume between lead and off floats / time taken to rise from off to lead float
  def inflow_rate
    time_diff = (@recent_pump_cycle.started_at - @recent_pump_state.reported_at).to_i
    time_taken = time_diff.zero? ? 1 : time_diff
    @lift_station.lead_to_off_volume / time_taken
  end

  # the total amount of liquid pumped out of the tank
  # NOTE: this should include the amount of liquid that flowed into the tank
  #       while the pump ran because water does not stop flowing into the tank
  #       while the pump is on
  # use the most recent inflow rate as an estimate
  def flow_total
    @lift_station.lead_to_off_volume + inflow_rate
  end

  # represents the rate of liquid pumped out of the tank
  # may be calculated as: 
  # total flow / time taken to fall from lead to off float
  def outflow_rate
    time_taken = @recent_pump_cycle.duration.nil?  ? 1 : @recent_pump_cycle.duration
    flow_total / time_taken
  end
end
