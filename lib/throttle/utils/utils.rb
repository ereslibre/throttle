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

require "pp"
require "bzip2"

module Throttle

    class Utils

      def self.action_to_filename(action)
        return nil if not action
        "#{action.split(/(?=[A-Z])/).join('_').downcase}"
      end

      def self.action_to_classname(action)
        return nil if not action
        "#{action[0].chr.upcase}#{action[1..-1]}"
      end

      def self.filename_to_classname(filename)
        return nil if not filename
        "#{filename.split("_").map { |w| w.capitalize }.join}"
      end

      def self.command_handler(command, opts)
        begin
          require "throttle/commands/#{action_to_filename command}"
          $0 = "#{$0} #{command}"
        rescue LoadError => error
          puts error if DEBUG
          puts "!!! Unknown command \"#{command}\". Run `#$0 --help' to learn more"
          return nil
        end
        Throttle.const_get(action_to_classname command).new opts
      end

      def self.compress(string)
        Bzip2.bzip2 string
      end

      def self.uncompress(stream)
        Bzip2.bunzip2 stream
      end

      def self.version_mismatch(version)
        # Dummy for now. When protocol changes we will have to add some heuristics here
        version != VERSION
      end

      def self.salt
        Digest::SHA1.hexdigest File.read("/dev/urandom", 1024)
      end

    end

end

class Object

  def respond_any_of?(*args)
    not multirespond_to?(*args).empty?
  end

  def multirespond_to?(*args)
    args.select { |m| respond_to? m }
  end

end
