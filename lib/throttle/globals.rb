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

module Throttle

### General settings ###############################################################################

  DEBUG                     = true
  DISABLE_API_DOCUMENTATION = false
  SSH_COMMAND               = "ssh"
  REMOTE_COMMAND            = "th serve -t #{DEBUG ? "" : "2> /dev/null"}"
  DEFAULT_PORT              = 8080
  # Whitelist is the accepted clients to use the API. nil denotes no restrictions on API consuming
  # IP_WHITELIST              = nil
  IP_WHITELIST              = [/127\.0\.0\.1/]

### Error definitions ##############################################################################

  # Something really wrong happened. We've logged it
  INTERNAL_ERROR            = 0

  # Invalid API URI
  INVALID_API_URI           = 1

  # Asked a resource for a method that is not implemented because it is not applicable
  NOT_APPLICABLE_METHOD     = 2

  # Invalid sessionId provided. It probably has expired, or someone is playing dirty
  INVALID_SESSION_ID        = 3

  # Invalid data provided to the method
  INVALID_DATA              = 4

  # IP is not allowed to query API
  IP_NOT_ALLOWED            = 5

### Internal error definitions #####################################################################

  # OK
  OK                        = 0

  # Version mismatch between client and server. Incompatible protocols
  VERSION_MISMATCH          = 1

end
