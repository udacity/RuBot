module SegmentAnalytics

  def identify(user)
    Analytics.identify(
      {
        user_id:  user.id.to_s,
        traits: {
          ndkey:      Rails.application.config.ndkey,
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
          ndkey:                Rails.application.config.ndkey,
          text:                 options[:text],
          channel_id:           options[:channel_id],
          channel_name:         options[:channel_name],
          interaction_id:       options[:interaction_id],
          interaction_trigger:  options[:interaction_trigger],
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
    if data.text
      channel_name = channel_id_to_name(data)
      user = User.where(slack_id: data.user).first
      track(
        user,
        "Message",
        :text =>          data.text,
        :channel_id =>    data.channel,
        :channel_name =>  channel_name
      )
    end
  end

  # def track_scheduled_message(user, message_id, message_text)
  #   track(
  #     user,
  #     "Scheduled Message",
  #     :message_id =>    message_id.to_s,
  #     :message_text =>  message_text
  #   )
  # end

  # def track_rescheduled_message(log, message_id, message_text)
  #   user = User.where(channel_id: log.channel_id).first
  #   track(
  #     user,
  #     "Scheduled Message",
  #     :message_id =>    message_id.to_s,
  #     :message_text =>  message_text
  #   )
  # end

  # def track_interactions(data, id, trigger, response)
  #   if data.text
  #     user = User.where(slack_id: data.user).first
  #     track(
  #       user, 
  #       "Interaction",
  #       :text =>                  data.text.downcase,  
  #       :interaction_id =>        id.to_s,
  #       :interaction_trigger =>   trigger,
  #       :interaction_response =>  response
  #     )
  #   end
  # end

end








