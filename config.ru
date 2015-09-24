#\ -w -p 8080

$:.unshift File.dirname(__FILE__) + '/lib'
$:.unshift File.dirname(__FILE__) + '/webapp'

require 'rubygems'
require 'webapp'

run ChartsWebapp.new
