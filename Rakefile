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
	`tar czf pkg/#{NAME}-#{VERSION}.tgz lib conf doc webapp config.ru Gemfile LICENSE Rakefile *.md *.gemspec`

end
