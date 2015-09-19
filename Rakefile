require 'rspec/core/rake_task'

task :default => [:run]

desc "run app locally"
task :run => "Gemfile.lock" do
  system 'ruby -I lib webapp/webapp.rb'
end

RSpec::Core::RakeTask.new(:spec) do |t|
	t.rspec_opts = "-I lib"
end
