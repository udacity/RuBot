class Interaction < ActiveRecord::Base
  def user_input=(val)
    write_attribute(:user_input, val.downcase)
  end
end
