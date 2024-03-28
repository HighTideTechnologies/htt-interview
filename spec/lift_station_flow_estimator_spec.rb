require 'rails_helper'

describe LiftStationFlowEstimator do
  subject(:estimator) { LiftStationFlowEstimator.new(lift_station:) }

  # significantly speeds up the test execution time
  before(:all) do
    @pump = FactoryBot.create(:pump_with_telemetry)
    @lift_station = FactoryBot.create(:lift_station, pump: @pump)
    @previous_cycle, @recent_cycle = @pump.pump_cycles.where.not(duration: nil).order(started_at: :asc).first(2)
  end

  let(:lift_station) { @lift_station }
  let(:pump) { @pump }

  describe '#perform' do
    it 'should not error' do
      expect { estimator.perform }.not_to raise_error
    end

    it 'should create a lift station cycle' do
      expect { estimator.perform }.to change { LiftStationCycle.count }.by(1)
    end
  end

  describe '#inflow_rate' do
    it 'should be implemented' do
      expect { estimator.inflow_rate }.not_to raise_error
    end

    it 'should calculate the correct inflow rate' do
      estimator.perform
      expected_inflow_rate = lift_station.lead_to_off_volume / (@recent_cycle.started_at - @previous_cycle.ended_at)

      expect(estimator.inflow_rate).to eq(expected_inflow_rate)
    end
  end

  describe '#flow_total' do
    it 'should be implemented' do
      expect { estimator.flow_total }.not_to raise_error
    end

    it 'should calculate the correct flow_total' do
      estimator.perform
      expected_flow_total = (estimator.inflow_rate * @recent_cycle.duration) + lift_station.lead_to_off_volume

      expect(estimator.flow_total).to eq(expected_flow_total)
    end
  end

  describe '#outflow_rate' do
    it 'should be implemented' do
      expect { estimator.outflow_rate }.not_to raise_error
    end

    it 'should calculate the correct inflow rate' do
      estimator.perform
      expected_outflow_rate = estimator.flow_total / @recent_cycle.duration

      expect(estimator.outflow_rate).to eq(expected_outflow_rate)
    end
  end
end
