require_relative File.join(File.dirname(__FILE__), '../../lib/shedcam.rb')

set :output, 'logs/cron.log'

every Shedcam::CONFIG['interval'].minutes do
  rake 'photo:capture'
end

every :day, :at => '01:00' do
  rake "schedule:daylight"
end
