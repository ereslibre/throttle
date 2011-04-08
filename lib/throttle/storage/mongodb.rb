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

require "mongo"
require "digest/sha1"
require "throttle/utils/utils"

module Throttle

  class MongoDB

    def initialize
      @connection = Mongo::Connection.new
      @db = @connection["throttle"]
      @users = @db["users"]
      @users.create_index "username"
      @sessions = @db["sessions"]
      @sessions.create_index "username"
      @tokens = @db["tokens"]
      @tokens.create_index "username"
      @tokens.create_index "token"
    end

    def find_user(username, session_id)
      if @users.find({ :username => username }).count == 1
        refresh_session session_id if session_id
        user = @users.find_one({ :username => username })
        return user["username"], user["realname"], user["email"]
      else
        return nil, nil, nil
      end
    end

    def login(username, password, save_session)
      session_id = nil
      token = nil
      token_expires = nil
      user = @users.find_one({ :username => username })
      if user and @users.find({ :username => username, :password => Digest::SHA1.hexdigest("#{password}#{user["salt"]}") }).count == 1
        random_data = File.read("/dev/urandom", 1024)
        session_id = Digest::SHA1.hexdigest "#{random_data}#{Time.now.to_f}"
        if save_session
          token = Digest::SHA1.hexdigest "#{random_data}#{Time.now.to_f}"
          token_expires = Time.now.to_i + 60 * 60 * 24 * 7
          @tokens.update({ :username => username }, { :username     => username,
                                                      :token        => token,
                                                      :tokenExpires => token_expires },
                                                    { :upsert       => true })
        end
        @sessions.update({ :username => username }, { :username       => username,
                                                      :sessionId      => session_id,
                                                      :sessionExpires => Time.now.to_i + 60 * 60 },
                                                    { :upsert         => true })
      end
      return session_id, token, token_expires
    end

    def logout(session_id)
      session = @sessions.find_one({ :sessionId => session_id })
      return false if not session
      username = session["username"]
      @sessions.remove({ :username => username })
      @tokens.remove({ :username => username })
      true
    end

    def login_with_token(token)
      session_id = nil
      if @tokens.find({ :token => token }).count == 1
        user_token = @tokens.find_one({ :token => token })
        username = user_token["username"]
        random_data = File.read("/dev/urandom", 1024)
        session_id = Digest::SHA1.hexdigest "#{random_data}#{Time.now.to_f}"
        @sessions.update({ :username => username }, { :username       => username,
                                                      :sessionId      => session_id,
                                                      :sessionExpires => Time.now.to_i + 60 * 60 },
                                                    { :upsert         => true })
      end
      session_id
    end

    def register(username, password, realname, email)
      return nil if @users.find({ :username => username }).count > 0
      salt = Utils.salt
      @users.insert({ :username => username,
                      :salt => salt,
                      :password => Digest::SHA1.hexdigest("#{password}#{salt}"),
                      :realname => realname,
                      :email => email })
      res = login(username, password, false)
      return res[0]
    end

    def is_session_valid(session_id)
      if @sessions.find({ :sessionId => session_id }).count == 1
        refresh_session session_id
        return true
      end
      false
    end

    def refresh_session(session_id)
      session_expires = Time.now.to_i + 60 * 60
      session = @sessions.find_one({ :sessionId => session_id })
      @sessions.update({ :sessionId => session_id },
                       { "$set" => { :sessionExpires => session_expires } }) if session["sessionExpires"] < session_expires
    end

    def update_tokens
      @tokens.remove({ :tokenExpires => { "$lt" => Time.now.to_i } })
    end

    def update_sessions
      @sessions.remove({ :sessionExpires => { "$lt" => Time.now.to_i } })
    end

    def clean_all
      @users.remove
      @sessions.remove
      @tokens.remove
    end

  end

end
