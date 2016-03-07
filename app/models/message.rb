class Message < ActiveRecord::Base
  validates_presence_of :text, :project, :delay
  validates_format_of :delay, :with => /\A[0-9]+[smhd]\Z/ 
  before_save :set_message_number

  private

    def set_message_number
      #This method sets the message number to equal the delay in seconds
      numeric_value = self.delay.gsub(/[^0-9]/, '').to_i
      if self.delay.include?("s")
        self.message_number = numeric_value
      elsif self.delay.include?("m")
        self.message_number = numeric_value * 60
      elsif self.delay.include?("h")
        self.message_number = numeric_value * 3600
      elsif self.delay.include?("d")
        self.message_number = numeric_value * 86400
      end
    end
end
