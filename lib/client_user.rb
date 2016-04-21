module ClientUser

  def get_users
    @users = User.all
  end

  def update_user_list(client)
    puts "Updating user list."
    get_users
    api_members = client.web_client.users_list.members
    save_user_on_update_list(api_members, @users)
    delete_user_on_update_list(api_members)
  end

  def save_user_on_update_list(api_members, users)
    api_members.each do |member|
      unless users.any? { |person| person.slack_id == member.id } || member.deleted
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

  def delete_user_on_update_list(api_members)
    to_delete = api_members.select { |member| member.deleted  == true }
    if to_delete
      get_users
      to_delete.each do |departed|
        user_to_delete = @users.select {|user| user.slack_id == departed.id}.first
        user_to_delete.delete if user_to_delete
      end
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

  def set_user(data)
    #will work with responses from :team_join and :user_change events
    get_users
    @user = @users.select { |person| person.slack_id == data.user.id }.first
  end

  def set_channel_id(client)
    get_users
    time = Time.now + 5
    @users.each do |user|
      identify(user)
      # unless user.channel_id
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
        #end
      end
    end
  end

end