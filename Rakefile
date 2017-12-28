require File.join(File.dirname(__FILE__), 'lib/shedcam.rb')

unless ENV['RACK_ENV'] == 'production'
  require 'rspec/core/rake_task'
  require 'coveralls/rake/task'
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'

  RSpec::Core::RakeTask.new
  Coveralls::RakeTask.new

  task :default => [:spec, 'jasmine:ci', 'coveralls:push']
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
  task :capture do
    filename = "%s.jpg" % now.iso8601
    path = "%s/%s" % [Shedcam::CONFIG['images'], now.strftime('%Y/%m/%d')]
    FileUtils.mkdir_p path
    sh "raspistill -o %s/%s" % [path, filename]
    FileUtils.cp "%s/%s" % [path, filename], "public/assets/images/latest.jpg"

    File.open "public/assets/images/latest.timestamp", 'w' do |f|
      Marshal.dump now, f
    end
  end
end

namespace :schedule do
  desc 'update schedule'
  task :update do
    sh 'bundle exec whenever --update-crontab --user pi'
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
