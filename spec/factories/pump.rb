INTERVAL = 2.minutes.freeze
COUNT = (Time.now.beginning_of_day.to_i - Time.now.yesterday.beginning_of_day.to_i) / INTERVAL.to_i

FactoryBot.define do
  factory :pump do
    after(:create) do |pump, _evaluator|
      FactoryBot.create :pump_state, pump:, reported_at: Time.now, active: false
    end
  end

  factory :pump_with_telemetry, class: Pump do
    after(:create) do |pump, _evaluator|
      time = Time.now.yesterday.beginning_of_day
      COUNT.times do
        FactoryBot.create :pump_state, pump:, reported_at: time
        time += INTERVAL
      end
    end
  end
end
