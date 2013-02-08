require 'factory_girl'

FactoryGirl.define do
  factory :ranking do
    association :rankeable, :factory => :site
    ranked_type "User" # default
  end
end