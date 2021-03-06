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

require "throttle/utils/remote_end"

module Throttle

  class SSHServer

    include RemoteEnd

    def initialize
      @remote_r = STDIN
      @remote_w = STDOUT
    end

    def serve(port)
      # Check for compatible protocols
      recv_plain_cmd { |version|
        version_mismatch = Utils.version_mismatch version
        send_json({ :error => version_mismatch ? VERSION_MISMATCH : OK })
        Process.exit if version_mismatch
      }

      recv_json { |command|
        send_json({ :cmd => "responseTest", :args => command })
      }
    end

  end

end
