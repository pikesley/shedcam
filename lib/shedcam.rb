require 'sinatra/base'
require 'tilt/erubis'
require 'json'
require 'yaml'

require_relative 'shedcam/helpers'
require_relative 'shedcam/racks'

module Shedcam
  class App < Sinatra::Base
    helpers do
      include Shedcam::Helpers
    end

    get '/' do
      headers 'Vary' => 'Accept'

      respond_to do |wants|
        wants.html do
          @timestamp = Marshal.load File.open 'public/assets/images/latest.timestamp'
          erb :index
        end

        wants.json do
          {
            app: 'Shedcam'
          }.to_json
        end
      end
    end

    # start the server if ruby file executed directly
    run! if app_file == $0

    not_found do
      status 404
      @title = '404'
      erb :oops
    end
  end
end
