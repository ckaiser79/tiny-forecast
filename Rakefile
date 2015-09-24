require 'rspec/core/rake_task'
require 'date'

VERSION=DateTime.now.strftime("%y%m%d")
NAME='tiny-forecast'

task :default => [:run]

desc "run app locally"
task :run => "Gemfile.lock" do
  system 'ruby -I lib webapp/webapp.rb'
end

RSpec::Core::RakeTask.new(:spec) do |t|
	t.rspec_opts = "-I lib"
end


task :package do

	FileUtils.mkdir_p 'pkg'
	filename = NAME + "-" + VERSION + ".tgz"
	`tar czf pkg/#{filename} lib conf doc webapp config.ru Gemfile LICENSE Rakefile *.md *.gemspec`
	throw "Unable to create package pkg/" + filename if $?.to_i > 0 
	puts "created package pkg/"+ filename
end
