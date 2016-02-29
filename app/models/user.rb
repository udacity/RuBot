class User < ActiveRecord::Base

  def self.user_age
    @users = User.all
    @users.each do |user|
      #user age is in days (86400 seconds).
      user.age = (Time.now - user.created_at) / 86400
      puts user.age
    end
  end

end