require 'rails_helper'

describe LiftStationFlowEstimator do
  let!(:pump) { FactoryBot.create(:pump_with_telemetry) }
  let!(:lift_station) { FactoryBot.create :lift_station, pump: }
  let!(:estimator_instance) { LiftStationFlowEstimator.new(lift_station:) }
  let!(:recent_pump_cycle) { lift_station.pump_cycles.last }
  let!(:recent_pump_state) { lift_station.pump.pump_states.last }

  describe '#perform' do
    it 'should not error' do
      expect { estimator_instance.perform }.not_to raise_error
    end

    it 'should create a lift station cycle' do
      expect { estimator_instance.perform }.to change { LiftStationCycle.count }.by(1)
    end
  end

  describe '#inflow_rate' do
  let!(:lift_station) { FactoryBot.create :lift_station }

    it 'should be implemented' do
      expect { estimator_instance.inflow_rate }.not_to raise_error(NotImplementedError)
    end

    # TODO: write a test validating LiftStationFlowEstimator#inflow_rate returns the correct inflow rate
    it 'should calculate the correct inflow rate' do
      expect(lift_station.lead_to_off_volume).to be_truthy
    end
  end

  describe '#outflow_rate' do
    it 'should be implemented' do
      expect { estimator_instance.outflow_rate }.not_to raise_error(NotImplementedError)
    end

    # TODO: write a test validating LiftStationFlowEstimator#outflow_rate returns the correct outflow rate
    it 'should calculate the correct inflow rate' do
    end
  end

  describe '#flow_total' do
    it 'should be implemented' do
      expect { estimator_instance.flow_total }.not_to raise_error(NotImplementedError)
    end

    # TODO: write a test validating LiftStationFlowEstimator#flow_total returns the correct flow rate
    it 'should calculate the correct flow_total' do
    end
  end
end
