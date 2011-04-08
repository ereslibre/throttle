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

module Throttle

  module RemoteEnd

### Plain uncompressed #############################################################################

    def send_plain_cmd(cmd)
      @remote_w.write "#{cmd.bytesize}\n#{cmd}"
      @remote_w.flush
    end

    def recv_plain_cmd
      payload_size = @remote_r.gets
      yield @remote_r.read payload_size.to_i
    end

#### Plain compressed ##############################################################################

    def send_cmd(cmd)
      send_plain_cmd Utils.compress cmd
    end

    def recv_cmd
      yield recv_plain_cmd { |response| Utils.uncompress response }
    end

#### JSON uncompressed #############################################################################

    def send_plain_json(json)
      send_plain_cmd json.to_json
    end

    def recv_plain_json
      yield recv_plain_cmd { |response| JSON.parse response }
    end

### JSON compressed ################################################################################

    def send_json(json)
      send_cmd json.to_json
    end

    def recv_json
      yield recv_cmd { |response| JSON.parse response }
    end

#### JSON compressed with reply ####################################################################

    def send_json_r(json)
      send_json json
      yield recv_json { |response| response }
    end

  end

end
