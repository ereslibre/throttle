# -*- coding: utf-8 -*-
# This file is part of Throttle.
#
# Copyright (C) 2011 Rafael Fernández López <ereslibre@ereslibre.es>
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

$: << File.join(File.expand_path(File.dirname(__FILE__)), "lib")

require "throttle/servers/httpserver"

puts "*** Storage refresher being launched"
Throttle::HttpServer.launch_storage_refresher

run Throttle::HttpServer::APIHandler
