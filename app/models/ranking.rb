class Ranking < ActiveRecord::Base

  belongs_to :rankeable, :polymorphic => true
  # Ranking values. Will be deleted if a Ranking is destroyed
  has_many  :values,
            :class_name => 'RankingValue',
            :order => 'position, id ASC',
            :dependent => :destroy

  validates :ranked_type,
            :presence => true

  validates :rankeable, :presence => true
  validate :ranked_type_call_existence
  scope :by_position, :order => :position

  # given a ranked item, return it's position in this ranking,
  # if any, or nil if the item isn't positioned on this ranking
  def ranked_item_position(ranked_object)
    self.values.find_by_ranked_object_id(ranked_object).try(:position)
  end

  def calculate(*args)
    rank_list = RankingRules.new.send(ranked_type_call, self, *args)
    ::RankingValue.transaction do
      self.values.delete_all
      rank_list.each_with_index do |subject_rank, index|
        ::RankingValue.create! do |rv|
          rv.ranking = self
          rv.value = subject_rank.value
          rv.position = index+1
          rv.ranked_object = subject_rank.subject
          rv.label = subject_rank.label
        end
      end
    end
  end

  private

  def ranked_type_call_existence
    unless self.ranked_type_call.nil? or RankingRules.new.respond_to?(self.ranked_type_call.to_sym)
      errors.add(:ranked_type_call, "Invalid Function name: #{self.ranked_type_call}")
    end
  end

end
