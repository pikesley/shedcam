[![Build Status](http://img.shields.io/travis/pikesley/shedcam.svg?style=flat-square)](https://travis-ci.org/pikesley/shedcam)
[![Dependency Status](http://img.shields.io/gemnasium/pikesley/shedcam.svg?style=flat-square)](https://gemnasium.com/pikesley/shedcam)
[![Coverage Status](http://img.shields.io/coveralls/pikesley/shedcam.svg?style=flat-square)](https://coveralls.io/r/pikesley/shedcam)
[![Code Climate](http://img.shields.io/codeclimate/github/pikesley/shedcam.svg?style=flat-square)](https://codeclimate.com/github/pikesley/shedcam)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://pikesley.mit-license.org)

# ShedCam

Bought a [ZeroView](https://thepihut.com/products/zeroview) in order to make some time-lapse movies of [my garden](https://www.flickr.com/photos/pikesley/collections/72157661958355852/) next year. I found the recommended client software was (inevitably) [some Python thing](https://github.com/alexellis/phototimer), so I turned (inevitably) to Ruby

## Installing it

First, you're going to want a recent Ruby on your Pi (I'm currently on 2.4.2). I swear by [rbenv](https://github.com/rbenv/rbenv) these days, but I understand other methods are available. You'll also want a big SD card in the Pi, because the images are pretty big. Then

```
git clone https://github.com/pikesley/shedcam
cd shedcam
bundle
bundle exec rake
```

## Configuring it

The only thing that's really worth tweaking is the [time-lapse interval](https://github.com/pikesley/shedcam/blob/master/config/config.yml#L1). The finest resolution available is 1 minute, because I'm using [whenever](https://github.com/javan/whenever) for scheduling, which is just a fancy wrapper around `cron`.

Once you've set that, run

```
bundle exec rake schedule:update
```

to update the `crontab`. It should now start taking photos...

## Running it

You'll want two terminals open, then

```
bundle exec rake run:sass
bundle exec rake run:app
```

and it should be running at [http://address.of.your.pi:9292](http://address.of.your.pi:9292)

## Actually installing it

To make it start at boot-time, run

```
rake app:install
```

which will put the necessary `systemd` start-up scripts in place

## Getting at the photos

It drops the photos into a directory called (by default) `timelapse-images`, with paths like

```
timelapse-images/2017/12/28/2017-12-28T13:53:16+00:00.jpg
```

so you ought to be able to `rsync` those out of there easily enough (I've not really thought that far ahead to be honest). Also, a quick back-of-a-fag-packet calculation suggest that running at full-res like this is going to generate 5 gigs of images per day. I might need to think about this...

## Making a movie

Get the images somewhere you have `ffmpeg` installed (I can very much recommended not doing this on the Pi), then some magic spells I've found effective would be something like:

```
ffmpeg -pattern_type glob -i "*.jpg" -c:v libx264 -vf fps=25 -pix_fmt yuv420p movie.mp4

```
