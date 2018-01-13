require_relative File.join(File.dirname(__FILE__), '../../lib/shedcam.rb')

set :output, 'logs/cron.log'

every :day, :at => '00:00' do
  rake "data:sync"
end
