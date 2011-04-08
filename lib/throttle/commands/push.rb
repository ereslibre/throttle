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
require "throttle/utils/remote_end"

module Throttle

  class Push

    include Command
    include RemoteEnd

    def launch_command
      host = ARGV[0]
      @remote_r = @remote_w = IO.popen("#{SSH_COMMAND} #{host} '#{REMOTE_COMMAND}'", "r+")

      begin
        # Check for compatible protocols
        send_plain_cmd VERSION
        recv_json { |response|
          if response["error"] != OK
            puts "!!! Remote end protocol is incompatible with this Throttle version (#{VERSION})"
            Process.exit
          end
        }
      rescue
        puts "!!! Throttle could not be executed on host or no connection could be established"
        Process.exit
      end

      puts "*** Server should return what we sent :-)"
      send_json_r({ :cmd => "clientTest", :args => "This is a test from the client" }) { |command|
        puts "*** Server says: #{command}"
      }
    end

  end

end
