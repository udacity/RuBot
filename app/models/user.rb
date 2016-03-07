class User < ActiveRecord::Base
  validates :slack_id, uniqueness: true

  def self.user_age
    puts "Running User.user_age."
    @users = User.all
    @users.each do |user|
      #user age is in days (86400 seconds).
      user.age = (Time.now - user.created_at) / 86400
      user.save
    end
  end

end