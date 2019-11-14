FactoryBot.define do
  factory :consumption do
    sequence(:detail) { |n| "consumption_#{n}" }
    sequence(:amount) { |n| n*1000 }
    sequence(:date)   { |n| Date.today - n }
    :tag
  end
end