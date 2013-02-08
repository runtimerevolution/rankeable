require "active_record"
require 'rankeable/engine' 
require 'rankeable/version' 
require 'rankeable/active_record'

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send(:include, Rankeable::ActiveRecord)
end