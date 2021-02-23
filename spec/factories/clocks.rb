FactoryBot.define do
  factory :clock do
    user { user }
    go_bed_at { Time.zone.now - 8.hours }
    wake_up_at { Time.zone.now }
    action { 'wake_up' }
  end
end
