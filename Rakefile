require 'rspec/core/rake_task'
require 'date'

VERSION=DateTime.now.strftime("%y%m%d")
NAME='tiny-forecast'

task :default => [:run]

desc "run app locally"
task :run => "Gemfile.lock" do
  require './webapp/webapp'
  ChartsWebapp.run!
end

RSpec::Core::RakeTask.new(:spec) do |t|
	t.rspec_opts = "-I lib"
end


task :package do

	includedFiles = []
	includedFiles.push 'lib' 
	includedFiles.push 'conf' 
	includedFiles.push 'doc' 
	includedFiles.push 'webapp' 
	includedFiles.push 'config.ru'
	includedFiles.push NAME + '.gemspec'
	includedFiles.push 'Gemfile'
	includedFiles.push 'LICENSE'
	includedFiles.push 'Rakefile'
	includedFiles.push 'README.md'
	
	filename = NAME + "-" + VERSION 
	FileUtils.mkdir_p 'pkg/' + filename
	FileUtils.cp_r includedFiles, 'pkg/' + filename + '/'
	
	`tar czf pkg/#{filename}.tgz -C pkg  #{filename}`
	throw "Unable to create package pkg/" + filename + ".tgz" if $?.to_i > 0 
	puts "created package pkg/"+ filename + ".tgz"
	
end
