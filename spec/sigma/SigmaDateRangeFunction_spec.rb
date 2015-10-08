require 'sigma'

describe Sigma::SigmaDateRangeFunction do

  before :each do
    @sigma = Sigma::SigmaDateRangeFunction.new (Date.today + 100)
  end

  it "uses factors" do
    @sigma = Sigma::SigmaDateRangeFunction.new (Date.today + 10)
    @sigma.addFactor 0.4, 0.7
    @sigma.addFactor 0.7, 1.1
    @sigma.addFactor 1.1, 1.4

    values = @sigma.run 32
    dumpArray values

    expect(values[2][1]).to be > 0
    expect(values[values.length - 1][1]).to be >= 31
  end

  it "honors milestones" do
    @sigma.milestones = [
        { 'date' => Date.today + 10, 'label' => 'foo' },
        { 'date' => Date.today + 20, 'label' => 'bar' }
    ]
    values = @sigma.run 320

    expect(values[10][2]).to eq 'foo'
    expect(values[20][2]).to eq 'bar'
    expect(values[11].size).to eq 3
    expect(values[10].size).to eq 3
  end

  it "calculates some values" do

    values = @sigma.run 320

    #dumpArray values

    expect(values[0][0].is_a?(Date)).to be true
    expect(values[0][1].class).to eq Fixnum

    expect(values[values.length - 1][0]).to eq (Date.today + 100)
    expect(values[0][0]).to eq Date.today

    expect(values[values.length - 1][1]).to be >= 319
    min = (320 * 0.03).to_i
    expect(values[0][1]).to be <= min

  end

  def dumpArray values
    values.each do |item|
      puts item.to_s
    end
  end
end
