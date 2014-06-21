FactoryGirl.define do
  factory :article do
    sequence(:title) { |n| "title-#{n}" }
    sequence(:body) { |n| "body-#{n}" }
    sequence(:url) { |n| "url-#{n}" }
    published_at { Time.now }
    source
  end
end
