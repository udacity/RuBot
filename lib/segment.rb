module Segment

  def set_up_segment
    @@analytics = Segment::Analytics.new({
      write_key: ENV['SEGMENT_WRITE_KEY']
    })
  end

  def identify(user)
    @@analytics.identify(
      {
        user_id: user.id,
        traits: {
          email:      user.email,
          real_name:  user.real_name,
          user_name:  user.user_name,
          channel_id: user.channel_id,
          pic:        user.pic,
          enrolled:   user.enrolled
        }
      }
    )
    puts "Identifying!"
  end

  def track(user, event, options = {})
    #optional arguments: text, event, interaction id, blast id and message id
    @@analytics.track(
      {
        user_id:    user.id,
        event:      event,
        properties: {
          text:                 options[:text],
          interaction_id:       options[:interaction_id],
          interaction_response: options[:interaction_response],
          message:              options[:message_id],
          message_text:         options[:message_text],
          blast:                options[:blast_id],
          blast_text:           options[:blast_text],
          datetime:             options[:datetime],
          enrolled:             user.enrolled
        }
      }
    )
  end

  def track_scheduled_message(user, message_id, message_text)
    track(
      user,
      "Scheduled Message",
      :message_id => message_id,
      :message_text => message_text,
      :datetime => Time.now.strftime("%a %b %e %Y %T")
    )
  end

  def track_interactions(data, id, response)
    puts "tracking working!"
    user = User.all.select {|user| user.slack_id == data.user}.first
    track(
      user, 
      "Interaction", 
      :text => data.text, 
      :interaction_id => id,
      :interaction_response => response,
      :datetime => Time.now.strftime("%a %b %e %Y %T")
    )
  end

end








