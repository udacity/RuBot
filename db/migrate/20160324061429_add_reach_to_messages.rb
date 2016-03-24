class AddReachToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :reach, :integer, :null => false, :default => 0
  end
end
