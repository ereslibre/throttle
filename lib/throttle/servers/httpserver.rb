# coding: utf-8

# This file is part of Throttle.
#
# Copyright (C) 2010 Rafael Fernández López <ereslibre@ereslibre.es>
#
# Throttle is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Throttle is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Throttle. If not, see <http://www.gnu.org/licenses/>.

require "json"
require "sinatra/base"
require "throttle/version"
require "throttle/globals"
require "throttle/utils/utils"
require "throttle/utils/error"
require "throttle/storage/mongodb"

module Throttle

  class HttpServer

    def self.launch_storage_refresher
      fork do
        db = MongoDB.new
        while true do
          db.update_tokens
          puts "*** Updating tokens" if DEBUG
          db.update_sessions
          puts "*** Updating sessions" if DEBUG
          sleep 60 * 60
        end
        Process.exit 0
      end
    end

    class APIHandler < Sinatra::Base

      Dir.glob(File.join(File.expand_path(File.join(File.dirname(__FILE__), "..", "api")), "*.rb")) do |file|
        require "throttle/api/#{File.basename(file, File.extname(file))}"
      end

      before do
        if IP_WHITELIST
          allowed = false
          IP_WHITELIST.each do |rule|
            (allowed = true) and break if request.ip =~ rule
          end
          halt Error.new(:errorCode => IP_NOT_ALLOWED).to_json if not allowed
        end
        headers "Access-Control-Allow-Origin" => "*"
      end

      not_found do
        Error.new(:errorCode => INVALID_API_URI).to_json
      end

      error do
        Error.new(:errorCode => INTERNAL_ERROR).to_json
      end

    end

    class WebHandler < APIHandler

      get "/" do
        send_file "#{settings.public}/index.html"
      end

    end

    def serve(port, public_dir)
      HttpServer.launch_storage_refresher
      if public_dir
        WebHandler.run! :host => "localhost", :port => port, :public => public_dir
      else
        puts "!!! Serving API only"
        APIHandler.run! :host => "localhost", :port => port
      end
    end

  end

end
