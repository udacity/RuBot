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

  def start_rubot
    @rubot.start!
  end

end
