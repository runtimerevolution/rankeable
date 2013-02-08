class Site < ActiveRecord::Base

  has_rankings

  attr_accessible :context, :url
end
