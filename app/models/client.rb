class Client < ActiveRecord::Base
  require 'pp'
  # include Segment

  ### Segment tracking methods ###

  def set_channel_info(client)
    @@channel_list = client.web_client.channels_list.channels
    s = Rufus::Scheduler.new
    s.every '15m' do
      @@channel_list = client.web_client.channels_list.channels || @@channel_list
    end
  end

  def channel_id_to_name(data)
    channel = nil
    if @@channel_list
      channel = @@channel_list.select {|channel| channel.id == data.channel}.first
    end
    channel_name = channel != nil ? channel.name : "nil"
  end

  def identify(user)
    Analytics.identify(
      {
        user_id: user.id.to_s,
        traits: {
          email:      user.email,
          real_name:  user.real_name,
          user_name:  user.user_name,
          channel_id: user.channel_id,
          pic:        user.pic
        }
      }
    )
  end

  def track(user, event, options = {})
    #optional arguments: text, event, interaction id, blast id and message id
    Analytics.track(
      {
        user_id:    user.id.to_s,
        event:      event,
        properties: {
          text:                 options[:text],
          channel_id:           options[:channel_id],
          channel_name:         options[:channel_name],
          interaction_id:       options[:interaction_id],
          interaction_response: options[:interaction_response],
          message_id:           options[:message_id],
          message_text:         options[:message_text],
          blast:                options[:blast_id],
          blast_text:           options[:blast_text]
        }
      }
    )
  end

  def track_message(data)
    channel_name = channel_id_to_name(data)
    user = User.where(slack_id: data.user).first
    # identify(user)
    track(
      user,
      "Message",
      :text =>          data.text,
      :channel_id =>    data.channel,
      :channel_name =>  channel_name
    )
  end

  def track_scheduled_message(user, message_id, message_text)
    track(
      user,
      "Scheduled Message",
      :message_id =>    message_id.to_s,
      :message_text =>  message_text
    )
  end

  def track_rescheduled_message(log, message_id, message_text)
    user = User.where(channel_id: log.channel_id).first
    track(
      user,
      "Scheduled Message",
      :message_id =>    message_id.to_s,
      :message_text =>  message_text
    )
  end

  def track_interactions(data, id, response)
    user = User.where(slack_id: data.user).first
    track(
      user, 
      "Interaction", 
      :text =>                  data.text, 
      :interaction_id =>        id.to_s,
      :interaction_response =>  response
    )
  end

  ### End Segment methods ###

  def setup_client
    puts "setup rubot!"
    @rubot = Slack::RealTime::Client.new(websocket_ping: 40)
    # Override the CA_FILE and CA_PATH in the embedded web client if they are set in the environment
    if ENV['CA_FILE'] and ENV['CA_PATH']    
        web_client = Slack::Web::Client.new(ca_file: ENV['CA_FILE'], ca_path: ENV['CA_PATH'], websocket_ping: 40)
        @rubot.web_client = web_client
    end
    @rubot
  end

  def get_users
    @users = User.all
  end

  def say_hello_on_start(client)
    client.on :hello do 
      puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
    end
  end

  def get_bot_user_id(client)
    client.on :hello do
      get_users
      puts "Bot name: #{client.self.name}"
      @@bot_id = @users.select { |bot| bot.user_name == client.self.name }.first.slack_id
      puts "Bot ID: #{@@bot_id}"
    end
  end

  def track_messages(client)
    client.on :message do |data|
      track_message(data)
    end
  end

  def add_new_user(client)
    client.on :team_join do |data|
      get_users
      unless @users.any? { |person| person.slack_id == data.user.id }
        @user = User.new(
          user_name:  data.user.name,
          real_name:  data.user.profile.real_name,
          slack_id:   data.user.id,
          email:      data.user.profile.email,
          pic:        data.user.profile.image_192,
          channel_id: client.web_client.im_open(user: data.user.id).channel.id
        )
        @user.save
        identify(@user)
      end
    end
  end

  def set_user(data)
    #will work with responses from :team_join and :user_change events
    get_users
    @user = @users.select { |person| person.slack_id == data.user.id }.first
  end

  def send_message(channel_id, text, client)
    client.web_client.chat_postMessage(
      channel: channel_id, 
      text: text,
      as_user: true,
      unfurl_links: false,
      unfurl_media: false
      )
  end

  def create_log(user, message)
    #message_number is "delay" in seconds.
    delivery_time = Time.now + message.message_number
    @log = Log.new(
      channel_id: user.channel_id,
      message_id: message.id,
      delivery_time: delivery_time
    )
    @log.save
  end

  def send_scheduled_messages(client)
    client.on :team_join do |data|
      sleep(2)
      set_user(data)
      @messages = Message.all.sort
      @messages.each do |message|
        create_log(@user, message)
        s = Rufus::Scheduler.new(:max_work_threads => 200)
        s.in message.delay do
          ActiveRecord::Base.connection_pool.with_connection do 
            send_message(@user.channel_id, message.text, client)
            track_scheduled_message(@user, message.id, message.text)
            message.reach += 1
            message.save
            Log.where(message_id: message.id).first.delete
          end
        end
      end
    end
  end

  def reschedule_messages(client)
    Log.all.each do |log|
      if log.delivery_time > Time.now
        s = Rufus::Scheduler.new(:max_work_threads => 200)
        s.at log.delivery_time do
          ActiveRecord::Base.connection_pool.with_connection do
            message = Message.find(log.message_id) 
            send_message(log.channel_id, message.text, client)
            track_rescheduled_message(log, log.message_id, message.text)
            message.reach += 1
            message.save
            log.delete
          end
        end
      end
    end
  end

  def update_user(client)
    client.on :user_change do |data|
      puts "A user changed! (And I'm still running. Yay!)"
      set_user(data)
      @user.user_name = data.user.name
      @user.real_name = data.user.profile.real_name
      @user.slack_id =  data.user.id
      @user.email =     data.user.profile.email
      @user.pic =       data.user.profile.image_192
      @user.save
      identify(@user)
    end
  end

  def respond_to_messages(client)
    client.on :message do |data|
      if @@bot_id && data.user != @@bot_id && data.channel[0] == "D"
        interaction = Interaction.where(user_input: data.text.downcase).first
        if interaction
          send_message(data.channel, interaction.response, client)
          track_interactions(data, interaction.id, interaction.response)
          interaction.hits += 1
          interaction.save
        else
          send_message(data.channel, Rails.application.config.standard_responses.sample, client)
          track_interactions(data, 0, "standard_response")
        end
      end
    end
  end

  def update_user_list(client)
    puts "Updating user list."
    get_users
    client.web_client.users_list.members.each do |member|
      unless @users.any? { |person| person.slack_id == member.id }
        @user = User.new(
          user_name: member.name,
          real_name: member.profile.real_name,
          slack_id:  member.id,
          email:     member.profile.email,
          pic:       member.profile.image_192
        )
        @user.save
      end
    end
  end

  def start_rubot(client)
    puts "START RUBOT!!!"
    client.start!
  end

  def set_channel_id(client)
    get_users
    time = Time.now + 5
    @users.each do |user|
      identify(user)
      unless user.channel_id
        if user.email
          time += 2
          s = Rufus::Scheduler.new(:max_work_threads => 200)
          s.at time do
            ActiveRecord::Base.connection_pool.with_connection do 
              user.channel_id = client.web_client.im_open(user: user.slack_id).channel.id
              user.save
              puts "Set channel id for user: #{user.user_name}"
            end
          end
        end
      end
    end
  end

  def kill_client_for_testing(client)
    s = Rufus::Scheduler.new
    s.in '5s' do
      # puts "Client before #{client.web_client.channels_list.channels}"
      puts "killing connection"
      client.stop!
      # sleep(3)
      # puts "Client after #{client.web_client.channels_list.channels}"
    end
  end

  def restart_client_if_connection_lost(client)
    # kill_client_for_testing(client)
    client.on :close do |data|
      puts 'Connection has been disconnected. Restarting.'
      Rails.application.config.client = setup_client
      initialize_bot(Rails.application.config.client)
    end
  end

  def argue_with_slackbot(client)
    client.on :message do |data|
      if data.user == "USLACKBOT"
        client.web_client.chat_postMessage(
          channel: data.channel, 
          text: "slackbot... what a dweeb.", 
          as_user: true,
          unfurl_links: false,
          unfurl_media: false
        )
      end
    end
  end

  def initialize_bot(client)
    say_hello_on_start(client)
    set_channel_info(client)
    track_messages(client)
    update_user_list(client)
    set_channel_id(client)
    get_bot_user_id(client)
    add_new_user(client)
    reschedule_messages(client)
    send_scheduled_messages(client)
    update_user(client)
    respond_to_messages(client)
    # argue_with_slackbot(client)
    restart_client_if_connection_lost(client)
    start_rubot(client)
  end

end
