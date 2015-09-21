# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Learn more: http://github.com/javan/whenever

# regeneartes the db every day
every 1.day, :at => '12:20 pm' do
  rake "db:seed"
end