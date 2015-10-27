#!/usr/bin/env ruby

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rubygems'
require 'bundler/setup'

require 'csv'
require 'yaml'

require 'pry'

class Main
  def initialize argv

    @options = {}

    argv << "-h" if argv.empty?

    p = OptionParser.new do |opts|
      opts.banner = <<EOD
Usage: tab2datayaml.rb [options]

Converts a tab delimited file into a yaml format, readable
by tiny-forecast.

tab file format:

date (yyyy-mm-dd) \\t <number>+

EOD

      opts.on("-i", "--in TAB", "tab input file, '-' for <STDIN>") do |v|
        @options[:tab] = v
      end

      opts.on("-o", "--out YAML", "yaml output file, '-' for <STDOUT>") do |v|
        @options[:yaml] = v
      end

      opts.on("-h", "--help", "Show this message") do |v|
        puts opts
        exit 2
      end

    end

    begin
      p.parse! argv
    rescue => e
      puts p
      puts e
      exit 2
    end

  end

  def run

    if @options[:tab] == '-'

      tab = Array.new

      ARGF.each do |line|
        a = Array.new

        line.split(/\t/).each do |r|
          r = r.chomp
          a.push r
        end

        tab.push a
      end

    else
      tab = CSV.read @options[:tab], {:col_sep => "\t"}
    end

    yaml = YAML.load '--- entries'

    entries = []

    tab.each do |line|
      
      date = Date.parse line[0]

      entry = {}
      entry['timestamp'] = date
      entry['values'] = []

      for i in 1..tab.length - 1
        entry['values'].push line[i].to_f
      end

      entries.push entry

    end

    e = {'entries' => entries}
    yaml = e.to_yaml

    if @options[:yaml]
      puts yaml
    else
      File.open(@options[:yaml], 'w') do |f|
        f.write yaml
      end
    end

  end
end

Main.new(ARGV).run

