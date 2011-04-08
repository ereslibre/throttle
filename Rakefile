$: << File.expand_path(File.dirname(__FILE__))

require "fileutils"
require "rake/testtask"
require "lib/throttle/version"

Rake::TestTask.new() { |t|
  t.libs << "throttle"
  t.test_files = FileList["tests/**/*.rb"]
  t.verbose = false
  t.warning = false
}

task :build do
  system "gem build throttle.gemspec"
end

task :install do
  system "gem install throttle-#{Throttle::VERSION}.gem"
end

task :serve => [:install] do
  puts "*** Visit http://localhost"
  system "th serve -p80 --root ./public"
end

task :certificate do
  system "openssl genrsa -des3 -out /etc/server.key 1024" or System.exit 1
  system "openssl req -new -key /etc/server.key -out /etc/server.csr" or System.exit 1
  FileUtils.cp "/etc/server.key", "/etc/server.key.org"
  system "openssl rsa -in /etc/server.key.org -out /etc/server.key" or System.exit 1
  system "openssl x509 -req -days 365 -in /etc/server.csr -signkey /etc/server.key -out /etc/server.crt"
end

task :all => :serve do
end

task :default => :all do
end
