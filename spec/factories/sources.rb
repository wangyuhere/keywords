FactoryGirl.define do
  factory :source do
    sequence(:title) { |n| "title-#{n}" }
    sequence(:url) { |n| "url-#{n}" }
    sequence(:feed_url) { |n| "feed_url-#{n}" }
  end
end
