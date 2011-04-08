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

require "test/unit"
require "throttle/globals"
require "throttle/api/session"
require "throttle/storage/mongodb"

module Throttle

  class SessionTest < Test::Unit::TestCase

    def setup
      @db = MongoDB.new
      @session = Session.new
    end

    def teardown
      @db.clean_all
    end

    def test_get
      # Test passing invalid data
      begin
        invalidData = Error.new(:errorCode => INVALID_DATA)
        assert_equal(invalidData, @session.get(nil))
        assert_equal(invalidData, @session.get({ "sessionId" => nil }))
        assert_equal(invalidData, @session.get({ "unrelated" => 10 }))
      end

      # Test returning an invalid session
      begin
        invalidSession = Success.new(:validSession => false)
        assert_equal(invalidSession, @session.get({ "sessionId" => "asdf4321asdf" }))
      end

      # Test returning a valid session
      register_test_user
      login_test_user
      begin
        validSession = Success.new(:validSession => true)
        assert_equal(validSession, @session.get({ "sessionId" => @session_id }))
      end

      # Test returning an invalid session again
      logout_test_user
      begin
        invalidSession = Success.new(:validSession => false)
        assert_equal(invalidSession, @session.get({ "sessionId" => @session_id }))
      end
    end

    def test_post
    end

    def test_delete
    end

    def test_service_name
    end

    def test_service_path
    end

#### Private ########################################################################################

    def register_test_user
      @db.register "test_user", "test_password", "Real Test User Name", "test@user.com"
    end

    def login_test_user(save_session = false)
      @session_id, _, _ = @db.login "test_user", "test_password", save_session
    end

    def logout_test_user
      @db.logout @session_id
    end

  end

end
