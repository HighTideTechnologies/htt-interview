# calculates estimates for the
#  -inflow rate
#  - flow rate
#  - flow total
# and creates a new LiftStationCycle to record the data
class LiftStationFlowEstimator
  def initialize(lift_station:)
    @lift_station = lift_station
    @pump_cycle = lift_station.pump.pump_cycles.where.not(started_at: nil, duration: nil).order(created_at: :desc).first
  end

  # calculate the values and create a new LiftStationCycle to record
  def perform
    LiftStationCycle.create(inflow_rate:, outflow_rate:, flow_total:, lift_station: @lift_station)
  end

  # represents the rate of liquid flow into a lift station tank
  # may be calculated as: 
  # volume between lead and off floats / time taken to rise from off to lead float
  def inflow_rate
    @lift_station.lead_to_off_volume / @pump_cycle.duration
  end

  # the total amount of liquid pumped out of the tank
  # NOTE: this should include the amount of liquid that flowed into the tank
  #       while the pump ran because water does not stop flowing into the tank
  #       while the pump is on
  # use the most recent inflow rate as an estimate
  def flow_total
    outflow_rate * @pump_cycle.duration
  end

  # represents the rate of liquid pumped out of the tank
  # may be calculated as: 
  # volume between lead and off floats / time taken to fall from lead to off float
  def outflow_rate
    @pump_cycle.ended? ? 0 : inflow_rate
  end
end
