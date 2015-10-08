module Sigma

  class SigmaDateRangeFunction

    attr_reader :endDate
    attr_accessor :startDate
    attr_writer :milestones

    def initialize endDate
      @endDate = endDate
      @startDate = Date.today
      @standardDeviation = 0.5
      @factor = {}
    end

    #
    # * maxPercentage - 0 < maxPercentage <= 1
    # * factor - floating number, normally between 1,5 to 0,8
    #
    def addFactor maxPercentage, factor
      @factor[maxPercentage] = factor
    end

    #
    # * factors - [ [0.8, 1.3] [0.4, 0.7] ], unsorted
    #
    def addAllFactors array
      array.each do |item|
        addFactor item[0], item[1]
      end
    end

    def clearFactors
      @factor = {}
    end

    def run maxValueY
      days = (@endDate - @startDate).to_f

      throw "invalidDate" if days < 0

      result = []


      #g = maxValueY.to_f
      g = 1.to_f
      f0 = g * 0.7

      for x in 0..days

        k = factor x, days
        nx = normalizeX x, days
        ee = Math::E ** (-1 * k * g * nx)
        gf0 = g / f0

        # https://de.wikipedia.org/wiki/Logistische_Funktion or more generic
        # https://de.wikipedia.org/wiki/Sigmoidfunktion
        y = g * (1 / (1 + ee * (gf0 - 1)))

        #y = 1 / (1 + (Math::E ** (-1 * k * nx)) * ((1/f0) - 1) )
        y = y * maxValueY.to_f

        #binding.pry

        xDate = @startDate + x

        item = Array.new
        item[0] = xDate
        item[1] = y.to_i
        item[2] = nil

        attachOptionalMilestone item

        result.push item

      end

      result
    end

    private

    def attachOptionalMilestone item
      return if @milestones.nil?

      date = item[0]

      @milestones.each do |ms|
        if ms['date'] == date
          item[2] = ms['label']
          return
        end
      end
    end

    def factor x, maxX

      percent = x / maxX

      #
      # [ [0.3, 1.4] [0.6, 1.1] [0.8, 0.9] ]
      #
      sortedArray = @factor.sort_by { |k, v| k }

      #puts percent.to_s + " - " + sortedArray.to_s
      sortedArray.each do |item|
        if percent < item[0]
          #puts "factor = " + item[1].to_s + " (border used = " + item[1].to_s + ")"
          return item[1]
        end
      end

      1.5
    end

    #
    # interesting area of logistical function is between
    # -6 and 6
    # all our x values must be in the area
    #
    def normalizeX x, maxX
      step = 8.to_f / maxX
      nx = -4 + x * step
      #puts nx
      nx
    end
  end
end
