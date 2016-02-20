class Client < ActiveRecord::Base

  def setup_client
    @rubot = Slack::RealTime::Client.new
  end

  def say_hello_on_start
    @rubot.on :hello do
      puts "Successfully connected, welcome '#{@rubot.self.name}' to the '#{@rubot.team.name}' team at https://#{@rubot.team.domain}.slack.com."
    end
  end

  def log_messages
    @rubot.on :message do |data|
      puts "#{data.user} says: #{data.text}"
    end
  end

  def get_users
    @rubot.on :team_join do |data|
      @users = User.all
      @rubot.users.each do |member| 
        unless @users.any? { |user| user.slack_id == member[0] }
          @user = User.new(
            user_name: member[1].name,
            real_name: member[1].real_name,
            slack_id:  member[0],
            email:     member[1].profile.email
          )
          @user.save
        end
      end
    end
  end

  def update_user
    #Needs to be completed
    @rubot.on :user_change do |data|
    end
  end

  def start_rubot
    @rubot.start!
  end

  def bot_behavior
    setup_client
    say_hello_on_start
    log_messages
    get_users
    start_rubot
  end

end
