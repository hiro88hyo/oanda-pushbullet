
# encoding: utf-8

class StockChart
  attr_accessor :data

  def initialize(data)
    @data = data
  end

  def SMA(period=7, offset=0)
    if((@data.length>=(period+offset)))
      return (@data.slice(offset, period).reduce(:+)).to_f/period.to_f
    end
  end

  def EMA(period=10, offset=0)
    if(@data.length>=(period+offset))
      res = Array.new
      factor = 2/(period + 1.0)
      ema = self.SMA(period, @data.length - period - 1)
      res.push ema
      @data.reverse.slice(period, @data.length - period - offset).each{|c|
        ema += factor * (c-ema)
        res.push ema
      }
      return res.reverse[offset]
    end
  end

  def BollingerBand(period=20, multiplier=1, offset=0)
    if(@data.length>=(period+offset))
      avg = self.SMA(period)
      return avg + (multiplier * Math.sqrt(@data.slice(offset, period).reduce(0.0){|r, i|
        r += (i-avg)**2
      }/period.to_f))
    end
  end

  def MACD_value(fast, slow, offset)
    return EMA(fast, offset)-EMA(slow, offset)
  end

  def MACD(fast=12, slow=26, signal=9)
    if(@data.length>=(slow + slow + signal))
      macd = Array.new
      signal.times{|i|
        macd.push(self.MACD_value(fast, slow, i))
      }
      return [macd[0], macd.reduce(:+).to_f/signal.to_f]
    end
  end

  def RSI(period=14, offset=0)
    if(@data.length>=(period+offset+1))
      a = @data.slice(offset, period+1).reverse
      positive = 0
      negative = 0
      a.each_index{|i|
        if i!=0
          diff = a[i] - a[i-1]
          if diff>0
            positive += diff
          else
            negative += -diff
          end
        end
      }
      return (positive/(positive+negative))*100
    end
  end
end
