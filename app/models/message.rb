class Message < ActiveRecord::Base
  validates_presence_of :text, :project, :delay
  validates_format_of :delay, :with => /\A[0-9]+[smhd]\Z/ 
end
