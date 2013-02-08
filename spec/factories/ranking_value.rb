require 'factory_girl'

FactoryGirl.define do
  sequence :position do |n|
    n
  end
  factory :ranking_value do
    association :ranking, :factory => :ranking
    association :ranked_object, :factory => :user
    value  { (rand * 100).to_i }
    position
  end
end