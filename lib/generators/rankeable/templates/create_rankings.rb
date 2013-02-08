class CreateRankings < ActiveRecord::Migration
  def self.up
    create_table :rankings do |t|
      t.string  :name
      t.string  :rankeable_type
      t.integer :rankeable_id

      t.string :ranked_type
      t.string :ranked_type_call

      t.timestamps
    end

    create_table :ranking_values do |t|
      t.references :ranking
      t.integer    :position
      t.integer    :value
      t.string     :label

      t.string  :ranked_object_type
      t.integer :ranked_object_id

      t.timestamps
    end
  end

  def self.down
    drop_table :rankings
    drop_table :ranking_values
  end
end
