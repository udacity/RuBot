class AddHitsToInteractions < ActiveRecord::Migration
  def change
    add_column :interactions, :hits, :integer, :null => false, :default => 0
  end
end
