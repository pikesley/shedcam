require 'httparty'

require File.join(File.dirname(__FILE__), 'lib/shedcam.rb')

unless ENV['RACK_ENV'] == 'production'
  require 'rspec/core/rake_task'
  require 'coveralls/rake/task'

  RSpec::Core::RakeTask.new
  Coveralls::RakeTask.new

  task :default => [:spec, 'coveralls:push']
end

namespace :run do
  desc 'start app'
  task :app do
    sh 'rackup -o 0.0.0.0'
  end

  desc 'clean-up and run compass'
  task :sass do
    sh 'compass clean && compass watch'
  end
end

namespace :photo do
  now = DateTime.now

  desc 'take photo'
  task :snap do
    if daylight now
      filename = "%s.jpg" % now.iso8601
      path = "%s/%s" % [Shedcam::CONFIG['images'], now.strftime('%Y/%m/%d')]
      FileUtils.mkdir_p path
      sh "raspistill -o %s/%s" % [path, filename]
      FileUtils.cp "%s/%s" % [path, filename], 'public/assets/images/latest.jpg'
    end
  end

  desc 'generate timestamp'
  task :timestamp do
    if daylight now
      File.open 'config/latest.timestamp', 'w' do |f|
        Marshal.dump now, f
      end
    end
  end

  desc 'capture and timestamp photo'
  task :capture do
    Rake::Task['photo:snap'].invoke
    Rake::Task['photo:timestamp'].invoke
  end
end

namespace :schedule do
  desc 'update schedule'
  task :update do
    sh 'bundle exec whenever --update-crontab --user pi'
  end

  desc 'get sunrise and sunset'
  task :daylight do
    res = HTTParty.get "https://api.sunrise-sunset.org/json?lat=%s&lng=%s" % [
      Shedcam::CONFIG['latitude'],
      Shedcam::CONFIG['longitude']
    ]
    data = (JSON.parse res.body)['results']
    File.open 'config/daylight.times', 'w' do |f|
      Marshal.dump ({
        light: (DateTime.parse data['astronomical_twilight_begin']),
        dark: (DateTime.parse data['astronomical_twilight_end'])
      }), f
    end
  end
end

namespace :app do
  desc 'install start-up scripts'
  task :install do
    sh 'bundle exec foreman export systemd -u pi -a shedcam /tmp/systemd/'
    sh 'sudo rsync -av /tmp/systemd/ /etc/systemd/system'
    sh 'sudo systemctl enable shedcam.target'
    sh 'sudo systemctl daemon-reload'
  end
end

def daylight now
  daylight = Marshal.load File.open 'config/daylight.times'
  (now > daylight[:light]) && (now < daylight[:dark])
end
