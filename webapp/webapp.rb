require 'rubygems'
require 'sinatra'
require 'sinatra/base'

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

class ChartsWebapp < Sinatra::Base

	def initialize 
		super
		@confDir = ENV['TINY_FORECAST_HOME']
		@confDir = File.dirname(__FILE__) + '/../conf/' if @confDir.nil?
	end

	def createLoader id
	  fileConfig = @confDir + '/' + id + '-config.yaml'
	  fileData   = @confDir + '/' + id + '-data.yaml'
	  loader = Sigma::YamlDataLoader.new fileConfig, fileData
	  loader.run
	  loader
	end

	def loadSigmaChart controller, loader, params
	  lines = loader.chartData
    controller.lines = lines

    sigma = Sigma::SigmaDateRangeFunction.new loader.endDate
    sigma.startDate = loader.startDate
    sigma.addAllFactors loader.factors
    totalLines = sigma.run loader.maxY

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
end