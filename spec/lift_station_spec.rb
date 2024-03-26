require 'rails_helper'

describe LiftStation, type: :model do
  let(:lift_station) { FactoryBot.create :lift_station, radius: 5, height: 10, lead_to_floor: 8, off_to_floor: 4 }

  describe '#total_tank_volume' do
    it 'is implemented' do
      expect { lift_station.total_tank_volume }.not_to raise_error(NotImplementedError)
    end

    it 'returns the correct volume' do
      expect(lift_station.total_tank_volume).to eq(785.3981633974483)
    end
  end

  describe '#lead_to_off_volume' do
    it 'is implemented' do
      expect { lift_station.lead_to_off_volume }.not_to raise_error(NotImplementedError)
    end

    it 'returns the correct volume' do
      expect(lift_station.lead_to_off_volume).to eq(314.1592653589793)
    end
  end
end
