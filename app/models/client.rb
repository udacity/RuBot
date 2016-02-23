class Client < ActiveRecord::Base

  def setup_client
    @rubot = Slack::RealTime::Client.new
  end

  def get_users
    @users = User.all
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

  def add_new_user
    #Needs to be tested using :team_join instead of :user_change
    @rubot.on :user_change do |data|
      unless @users.any? { |user| user.slack_id == data.user.id }
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

  def send_welcome_message
    @rubot.on :team_join do |data|
      channel_id = @rubot.web_client.im_open(user: data.user.id).channel.id
      @rubot.web_client.chat_postMessage(channel: channel_id, text: "Testing", username: "RuBot")
      # text param need to be something like Message.where(message_number: 1)
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
    # Need to figure out way to defend against lost connection.
    setup_client
    get_users
    say_hello_on_start
    #log_messages
    add_new_user
    send_welcome_message
    start_rubot
  end

end
