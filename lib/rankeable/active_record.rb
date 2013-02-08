module Rankeable
	module ActiveRecord
		extend ActiveSupport::Concern

		module ClassMethods
      def is_rankeable
        has_many :ranking_values, :as => :ranked_object

        def is_rankeable?
          true
        end
      end

      def has_rankings
        has_many :rankings, :as => :rankeable
      end

      def is_rankeable?
        false
      end
    end
	end
end