require 'rubygems'
require 'sinatra'
require 'erb'

require 'chartkick'
require 'sigma'

class ChartController

  attr_accessor :title
  attr_accessor :lines

  def initialize
    @lines = []
    @title = "Sample Chart"
  end

end

get '/charts/sigma/:id.html' do

  fileConfig = File.dirname(__FILE__) + '/../conf/' + params['id'] + '-config.yaml'
  fileData   = File.dirname(__FILE__) + '/../conf/' + params['id'] + '-data.yaml'
  loader = Sigma::YamlDataLoader.new fileConfig, fileData

  loader.run
  lines = loader.chartData

  sigma = Sigma::SigmaDateRangeFunction.new loader.endDate
  sigma.startDate = loader.startDate
  sigma.addAllFactors loader.factors
  totalLines = sigma.run loader.maxY


  controller = ChartController.new
  controller.lines = lines
  controller.title = params['id']

  h =  { :name => 'best-expected-line', :data => totalLines }
  controller.lines.push h

  erb params['id'].to_sym, :locals => { :d => controller }
end

