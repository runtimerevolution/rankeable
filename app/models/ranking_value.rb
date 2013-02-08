class RankingValue < ActiveRecord::Base

  # associations
  belongs_to :ranking
  belongs_to :ranked_object, :polymorphic => true

  # validations
  validates :value, :position, :ranking, :ranked_object, :presence => true
  validates_uniqueness_of :position, :scope => [:ranking_id]

  # scoping by ranking
  scope :for_ranking, ->(ranking) { where(:ranking_id => ranking.try(:id)) }
end