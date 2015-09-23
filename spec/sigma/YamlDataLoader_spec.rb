require 'sigma'

describe Sigma::YamlDataLoader do

  before :each do
    config = File.dirname(__FILE__) + '/sample-config.yaml'
    data   = File.dirname(__FILE__) + '/sample-data.yaml'
    @loader = Sigma::YamlDataLoader.new config, data
  end

  it "reads a yaml file by absolute path" do

    @loader.run
    result = @loader.chartData

    expect(result.nil?).to be false
    expect(result.length).to be >0
  end

  it "reads factors" do
    @loader.run
    factors = @loader.factors
    expect(factors.length).to eq 3
    expect(factors[0]).to eq [0.5, 0.8]
    expect(factors[2]).to eq [1.1, 1.5]
  end

  it "reads maxY value" do
    @loader.run
    expect(@loader.maxY).to eq 320
  end
  
  it "reads template" do
    @loader.run
    expect(@loader.template).to eq 'sample'
  end  

  it "reads correct values (date is date)" do

    @loader.run
    result = @loader.chartData
    date = Date.parse('2015-10-01')

    expect(result[0][:name]).to eq 'open issues'
    expect(result[1][:name]).to eq 'total issues'
    expect(result[2][:name]).to eq 'testable issues'

    expect(result.length).to eq 3
    expect(result[0].length).to eq 2
    expect(result[0][:data].length).to eq 9
    expect(result[0][:data][0].length).to eq 2

    #binding.pry
    expect(result[0][:data][0][0]).to eq Date.parse('2015-10-01')
    expect(result[0][:data][1][0]).to eq Date.parse('2015-10-03')
    expect(result[0][:data][2][0]).to eq Date.parse('2015-10-04')

    expect(result[0][:data][0][1]).to eq 100
    expect(result[1][:data][0][1]).to eq 200
    expect(result[2][:data][0][1]).to eq 300

    expect(result[0][:data][0][0]).to eq date
    expect(result[1][:data][0][0]).to eq date
    expect(result[2][:data][0][0]).to eq date

    expect(result[0][:data][1][1]).to eq 120
    expect(result[1][:data][1][1]).to eq 220
    expect(result[2][:data][1][1]).to eq 320

    date = Date.parse '2015-10-03'
    expect(result[0][:data][1][0]).to eq date
    expect(result[1][:data][1][0]).to eq date
    expect(result[2][:data][1][0]).to eq date


  end

end