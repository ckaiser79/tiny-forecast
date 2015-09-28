require 'yaml'
require 'pry'

module Sigma

  class YamlDataLoader

    attr_reader :maxY
    attr_reader :chartData
    attr_reader :factors

    def initialize configFileName, dataFileName

      @yamlConfig = YAML.load_file configFileName
      @yamlData = YAML.load_file dataFileName
      @maxY
    end

    def run chartId
      #
      # e.g.[
      #       { name: 'open-items' , data: [[x1, y1_1], [x2, y1_2]] },
      #       { name: 'total-items', data: [[x1, y2_1], [x2, y2_2]] }
      #     ]
      #

      loadChartData chartId
      loadFactors

    end

    def endDate
      @yamlConfig['end-date']
    end

    def startDate
      @yamlConfig['start-date']
    end

    def template
      tpl = @yamlConfig['template']
      tpl = 'sample' if tpl.nil?

      tpl
    end

    private

    def loadChartData chartId
      @maxY = -1
      @chartData = []

      data = @yamlData
      store = Hash.new

      regexp = /\s*([^\[]+)\s+\[\s*([^\]]+)\s*\]/

      for j in 0..data['entries'].length - 1

        entry = data['entries'][j]

        for k in 0..data['labels'].length - 1

          label = []
          matchdata = regexp.match data['labels'][k]

          if matchdata.nil?
            label[0] = data['labels'][k]
            label[1] = data['labels'][k]
          else
            label[0] = matchdata[2]
            label[1] = matchdata[1]
          end

          if lineIncluded? chartId, label[0]
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

      end

      store.each do |k, v|
        r = {:name => k[1], :data => v}
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
          @factors.push [factorDefinition[0].to_f, factorDefinition[1].to_f]
        end
      end
    end

    def lineIncluded? chartId, key

      config = @yamlConfig['charts-' + chartId]
      result = true

      if not config.nil?
        array = config['included-data']
        result = array.include? key
      end

      result
    end

  end

end
