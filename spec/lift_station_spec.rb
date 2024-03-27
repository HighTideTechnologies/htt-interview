require 'rails_helper'

describe LiftStation do
  describe '#total_tank_volume' do
    let(:lift_station) { FactoryBot.create :lift_station }

    it 'is implemented' do
      expect { lift_station.total_tank_volume }.not_to raise_error(NotImplementedError)
    end

    it 'returns the correct volume' do
      # Assuming radius = 5 and height = 10 for example
      expect(lift_station.total_tank_volume).to be_within(0.001).of(785.398) # Expected value for given dimensions
    end
  end

  describe '#lead_to_off_volume' do
    let(:lift_station) { FactoryBot.create :lift_station }

    it 'is implemented' do
      expect { lift_station.lead_to_off_volume }.not_to raise_error(NotImplementedError)
    end

    # TODO: Write a test for lead_to_off_volume method
    it 'returns the correct volume between lead float and off float' do
      expect(lift_station.lead_to_off_volume).to eq(0) # Assuming off_to_floor is equal to lead_to_floor initially
    end
  end

end
