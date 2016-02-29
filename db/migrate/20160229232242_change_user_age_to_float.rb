class ChangeUserAgeToFloat < ActiveRecord::Migration
  def up
    change_column :users, :age, :float
  end

  def down
    change_column :users, :age, :integer
  end
end
