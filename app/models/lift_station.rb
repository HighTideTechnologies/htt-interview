# Represents a lift station for water/wastewater utilities. Consist of:
# - pump
# - a tank
# - a lead float (at fixed height in tank)
# - an off float (at fixed height in tank)
class LiftStation < ApplicationRecord
  belongs_to :pump, class_name: 'Pump'
  has_many :pump_cycles, through: :pump

  # TODO: implement method
  # The total volume of the lift stations tank
  def total_tank_volume
    pi * radius**2 * height
  end

  # TODO: implement method
  # The volume of the tank from the height of the off float to the height of the lead float
  def lead_to_off_volume
    pi * radius**2 * (lead_to_floor - off_to_floor)
  end

  private

  def pi
    Math::PI
  end
end
