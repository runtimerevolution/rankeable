class User < ActiveRecord::Base

  is_rankeable
  attr_accessible :name
end
