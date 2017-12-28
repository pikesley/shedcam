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
  desc 'take photo'
  task :capture do
    now = DateTime.now
    # filename = "%s.jpg" % now.strftime('%Y%m%d%H%M%S')
    filename = "%s.jpg" % now.iso8601
    path = "%s/%s" % [Shedcam::CONFIG['images'], now.strftime('%Y/%m/%d')]
    FileUtils.mkdir_p path
    sh "raspistill -o %s/%s" % [path, filename]
    FileUtils.cp "%s/%s" % [path, filename], "public/assets/images/latest.jpg"
  end
end

namespace :schedule do
  desc 'update schedule'
  task :update do
    sh 'bundle exec whenever --update-crontab --user pi'
  end
end
