# Represents a lift station for water/wastewater utilities. Consist of:
# - pump
# - a tank
# - a lead float (at fixed height in tank)
# - an off float (at fixed height in tank)
class LiftStation < ApplicationRecord
  belongs_to :pump, class_name: 'Pump'
  has_many :lift_station_cycles

  def total_tank_volume
    Math::PI * radius**2 * height
  end

  def lead_to_off_volume
    Math::PI * radius**2 * (lead_to_floor - off_to_floor)
  end
end
