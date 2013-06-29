# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :cron_log, "/path/to/my/cron_log.log"
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

set :output, nil
set :cron_log, "/dev/null"
 
every 1.day, :at => '4:30 am' do
  runner "Achievement.update_all_achievement_associations", :output => {:error => nil, :standard => nil}
  runner "NetworkImpact.automatically_calculate_stats", :output => {:error => nil, :standard => nil}
end

# start our 
every 1.minute do
  rake "ensure_dj_is_started", :output => {:error => nil, :standard => nil}
end

every :hour do 
  command "cd /data/1well/current && sudo RAILS_ENV=production rake ts:config && sudo RAILS_ENV=production rake ts:rebuild", :output => {:error => nil, :standard => nil} 
end
