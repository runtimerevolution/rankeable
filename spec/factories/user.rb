require 'factory_girl'

FactoryGirl.define do
  factory :user do
    name "Chuck Norris"
    points  { (rand * 100).to_i }
  end
end