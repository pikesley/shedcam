module Shedcam
  CONFIG = YAML.load_file('config/config.yml') || {}

  def self.daylight now
    daylight = Marshal.load File.open 'config/daylight.times'
    (now > daylight[:light]) && (now < daylight[:dark])
  end

  def self.get_daylight_times
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

  def self.jpg_name now
    "%s.jpg" % now.strftime('%Y%m%dT%H%M%S')
  end

  def self.jpg_path now
    now.strftime '/%Y/%m/%d'
  end

  def self.raspistill_flags
    begin
      return " %s" % Shedcam::CONFIG['raspistill_flags'].join(' ')
    rescue NoMethodError
      return ''
    end
  end
end
