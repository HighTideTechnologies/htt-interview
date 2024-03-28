# calculates estimates for the
#  -inflow rate
#  - flow rate
#  - flow total
# and creates a new LiftStationCycle to record the data
class LiftStationFlowEstimator
  attr_reader :lift_station,
              :pump_cycles,
              :recent_finished_pump_cycle,
              :previous_finished_pump_cycle

  def initialize(lift_station:)
    @lift_station = lift_station
    @pump_cycles = @lift_station.pump_cycles

    @previous_finished_pump_cycle, @recent_finished_pump_cycle =
      pump_cycles.where.not(duration: nil).order(started_at: :asc).first(2)
  end

  # calculate the values and create a new LiftStationCycle to record
  def perform
    lift_station.lift_station_cycles.create!(build_params)
  end

  # represents the rate of liquid flow into a lift station tank
  def inflow_rate
    return @inflow_rate if defined?(@inflow_rate)

    inflow_duration = recent_finished_pump_cycle.started_at - previous_finished_pump_cycle.ended_at

    @inflow_rate = lift_station.lead_to_off_volume / inflow_duration
  end

  # the total amount of liquid pumped out of the tank
  # NOTE: this should include the amount of liquid that flowed into the tank
  #       while the pump ran because water does not stop flowing into the tank
  #       while the pump is on
  # use the most recent inflow rate as an estimate
  def flow_total
    return @flow_total if defined?(@flow_total)

    inflow_during_pump = inflow_rate * recent_finished_pump_cycle.duration

    @flow_total = inflow_during_pump + lift_station.lead_to_off_volume
  end

  # represents the rate of liquid pumped out of the tank
  def outflow_rate
    return @outflow_rate if defined?(@outflow_rate)

    @outflow_rate = flow_total / recent_finished_pump_cycle.duration
  end

  private

  def build_params
    if recent_finished_pump_cycle && previous_finished_pump_cycle
      # arguments order is important
      { inflow_rate:, flow_total:, outflow_rate: }
    else
      { inflow_rate: 0, flow_total: 0, outflow_rate: 0 }
    end
  end
end
