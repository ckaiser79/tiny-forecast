require 'yaml'
require 'pry'

module Sigma

  class YamlDataLoader

    attr_reader :maxY
    attr_reader :chartData
    attr_reader :factors

    def initialize configFileName, dataFileName

      @yamlConfig = YAML.load_file configFileName
      @yamlData   = YAML.load_file dataFileName
      @maxY
    end

    def run
      #
      # e.g.[
      #       { name: 'open-items' , data: [[x1, y1_1], [x2, y1_2]] },
      #       { name: 'total-items', data: [[x1, y2_1], [x2, y2_2]] }
      #     ]
      #

      loadChartData
      loadFactors

    end

    def endDate
      @yamlConfig['end-date']
    end

    def startDate
      @yamlConfig['start-date']
    end	
	
    private

    def loadChartData
      @maxY = -1
      @chartData = []

      data = @yamlData
      store = Hash.new

      for j in 0..data['entries'].length - 1

        entry = data['entries'][j]

        for k in 0..data['labels'].length - 1

          label = data['labels'][k]
          values = store[label]

          if values.nil?
            values = Array.new
            store[label] = values
          end

          if @maxY < entry['values'][k]
            @maxY = entry['values'][k]
          end

          values.push [entry['timestamp'], entry['values'][k]]
        end

      end

      store.each do |k, v|
        r = {:name => k, :data => v}
        @chartData.push r
      end
    end

    def loadFactors
      config = @yamlConfig
      @factors = []
      factors = config['factors']
      if not factors.nil?
        factors.each do |item|
          factorDefinition = item.split(/\s+/)
          @factors.push [ factorDefinition[0].to_f, factorDefinition[1].to_f ]
        end
      end
    end

  end

end
