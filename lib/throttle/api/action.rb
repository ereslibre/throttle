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

require "throttle/utils/error"
require "throttle/utils/success"

module Throttle

  module Action

    def self.get(path, opts = {}, &block)
      ::Sinatra::Base.get "/api#{path}", opts, &block
    end

    def self.post(path, opts = {}, &block)
      ::Sinatra::Base.post "/api#{path}", opts, &block
    end

    def self.put(path, opts = {}, &block)
      ::Sinatra::Base.put "/api#{path}", opts, &block
    end

    def self.delete(path, opts = {}, &block)
      ::Sinatra::Base.delete "/api#{path}", opts, &block
    end

  end

end
