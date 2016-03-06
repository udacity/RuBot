class AddDelayToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :delay, :string
  end
end
