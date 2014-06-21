FactoryGirl.define do
  factory :word do
    sequence(:name) {|n| "name#{n}" }
  end
end
