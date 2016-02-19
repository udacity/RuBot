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
    @rubot.on :user_change do |data|
      @rubot.users.each do |user| 
        p user[1].name
        p user[1].real_name
        p user[0]
        p user[1].profile.email
      end
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
