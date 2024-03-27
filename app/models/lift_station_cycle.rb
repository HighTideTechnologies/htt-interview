# calculated after the end of a pump_cycle
# contains estimations for:
#  - inflow rate
#  - outflow rate
#  - total flow volume
class LiftStationCycle < ApplicationRecord
  belongs_to :lift_station

  def self.calculate_inflow_rate(lift_station_id)
    lift_station = LiftStation.find(lift_station_id)
    total_tank_volume = lift_station.total_tank_volume
    lead_to_off_volume = lift_station.lead_to_off_volume
    pump_cycles = PumpCycle.where(pump_id: lift_station.pump_id)

    inflow_rate = pump_cycles.sum do |cycle|
      cycle_duration = cycle.duration / 60.0 # Convert seconds to minutes
      (total_tank_volume / cycle_duration) - lead_to_off_volume
    end

    inflow_rate / pump_cycles.count # Average inflow rate
  end

  def self.calculate_outflow_rate(lift_station_id)
    lift_station = LiftStation.find(lift_station_id)
    pump_cycles = PumpCycle.where(pump_id: lift_station.pump_id)

    outflow_rate = pump_cycles.sum do |cycle|
      cycle.duration > 0 ? lift_station.total_tank_volume / cycle.duration : 0
    end

    outflow_rate / pump_cycles.count # Average outflow rate
  end

  def self.calculate_total_flow(lift_station_id)
    lift_station = LiftStation.find(lift_station_id)
    pump_cycles = PumpCycle.where(pump_id: lift_station.pump_id)

    total_flow = pump_cycles.sum { |cycle| cycle.duration > 0 ? lift_station.total_tank_volume : 0 }

    total_flow / pump_cycles.count # Average total flow
  end
end
