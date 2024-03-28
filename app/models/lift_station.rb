# Represents a lift station for water/wastewater utilities. Consist of:
# - pump
# - a tank
# - a lead float (at fixed height in tank)
# - an off float (at fixed height in tank)
class LiftStation < ApplicationRecord
  belongs_to :pump
  has_many :lift_station_cycles, dependent: :destroy
  has_many :pump_cycles, through: :pump

  # The total volume of the lift stations tank
  def total_tank_volume
    return @total_tank_volume if defined?(@total_tank_volume)

    @total_tank_volume = Math::PI * radius**2 * height
  end

  # The volume of the tank from the height of the off float to the height of the lead float
  def lead_to_off_volume
    return @lead_to_off_volume if defined?(@lead_to_off_volume)

    @lead_to_off_volume = Math::PI * radius**2 * (lead_to_floor - off_to_floor)
  end
end
