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

def createLoader id
  fileConfig = File.dirname(__FILE__) + '/../conf/' + id + '-config.yaml'
  fileData   = File.dirname(__FILE__) + '/../conf/' + id + '-data.yaml'
  loader = Sigma::YamlDataLoader.new fileConfig, fileData
  loader.run
  loader
end

def loadSigmaChart controller, loader, params
  lines = loader.chartData

  sigma = Sigma::SigmaDateRangeFunction.new loader.endDate
  sigma.startDate = loader.startDate
  sigma.addAllFactors loader.factors
  totalLines = sigma.run loader.maxY

  controller.lines = lines

  h =  { :name => 'best-expected-line', :data => totalLines }
  controller.lines.push h
end

get '/charts/:id/:file.html' do
  file = params['file']
  loader = createLoader params['id']
  
  controller = ChartController.new  
  controller.title = params['id']
  
  loadSigmaChart(controller, loader, params) if file == 'sigma'
    
  template = loader.template + '-' + file
  layout = loader.template + '-layout'
  erb template.to_sym, :layout => layout.to_sym, :locals => { :d => controller }
end

get '/charts/:id/' do
	redirect to('/charts/' + params['id'] + '/index.html')
end
