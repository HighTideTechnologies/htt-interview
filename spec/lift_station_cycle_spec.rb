require 'rails_helper'

describe LiftStationCycle do
  describe '#total_tank_volume' do
    let(:lift_station) { FactoryBot.create :lift_station }

    it 'is implemented' do
      expect { lift_station.total_tank_volume }.not_to raise_error(NotImplementedError)
    end

    # TODO: write a test validating 'LiftStation#total_tank_volume' returns the correct volume
    it 'returns the correct volume' do
    end
  end

  describe '#lead_to_off_volume' do
    let(:lift_station) { FactoryBot.create :lift_station }

    it 'is implemented' do
      expect { lift_station.lead_to_off_volume }.not_to raise_error(NotImplementedError)
    end

    # TODO: write a test validating 'LiftStation#lead_to_off_volume' returns the correct volume
    it 'returns the correct volume' do
    end
  end
end
