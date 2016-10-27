FactoryGirl.define do
  factory :game do
    played_at Time.now
    association :winner, factory: :user
  end
end
