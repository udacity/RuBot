# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :environment, 'development'
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# whenever --update-crontab rubotTasks
# create cronjob

# crontab -r
# clear existing cronjobs

# crontab -l
# lists cronjobs

every 1.day, :at => '10:10 am' do
  runner "User.user_age"
  # runner "Message.send_messages"
end