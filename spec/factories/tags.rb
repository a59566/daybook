FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "tag_#{n}" }
    sequence(:display_order)
  end
end