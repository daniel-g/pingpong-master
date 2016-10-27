FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@regalii.com"
  end

  factory :user do
    email
    password 'secret123'
    rating Time.now
  end
end
