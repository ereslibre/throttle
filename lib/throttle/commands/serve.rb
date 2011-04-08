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

require "throttle/commands/command"
require "throttle/servers/sshserver"
require "throttle/servers/httpserver"

module Throttle

  class Serve

    include Command

    def initialize(opts)
      $options[:port] = DEFAULT_PORT
      opts.on('-p', '--port PORT', 'Port where the server will listen') do |port|
        $options[:port] = port
      end

      $options[:root] = nil
      opts.on('-r', '--root ROOT', 'Root dir where static content is located') do |root|
        $options[:root] = root
      end

      $options[:transfer] = false
      opts.on('-t', '--transfer', 'Enable transfer mode (SSH). Internal only.') do
        $options[:transfer] = true
      end
    end

    def launch_command
      if $options[:transfer]
        SSHServer.new.serve $options[:port]
      else
        HttpServer.new.serve $options[:port], $options[:root]
      end
    end

  end

end
