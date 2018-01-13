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
    if Shedcam.daylight now
      filename = Shedcam.jpg_name now
      path = "%s/%s" % [Shedcam::CONFIG['images'], Shedcam.jpg_path(now)]
      fullpath = "%s/%s" % [path, filename]
      FileUtils.mkdir_p path
      sh "raspistill --output %s%s" % [fullpath, Shedcam.raspistill_flags]
      FileUtils.cp fullpath, 'public/assets/images/latest.jpg'
    end
  end

  desc 'generate timestamp'
  task :timestamp do
    if Shedcam.daylight now
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

namespace :data do
  desc 'rsync photos from shedcam'
  task :sync do
    Rsync.run "pi@%s:shedcam/timelapse-images/" % Shedcam::CONFIG['shedcam-address'], Shedcam::CONFIG['archive'], ['-a'] #, '--dry-run', '--remove-source-files']
  end
end

namespace :schedule do
  desc 'update shedcam schedule'
  task :shedcam do
    sh 'bundle exec whenever --load-file config/shedcam-schedule.rb --update-crontab --user pi'
  end

  desc 'update archive schedule'
  task :archive do
    sh 'bundle exec whenever --load-file config/archive-schedule.rb --update-crontab --user pi'
  end

  desc 'get sunrise and sunset data'
  task :daylight do
    Shedcam.get_daylight_times
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

namespace :ssh do
  desc 'copy keys from archive server to shedcam'
  task :send_keys do
    sh "ssh-copy-id pi@%s" % Shedcam::CONFIG['shedcam-address']
  end
end
