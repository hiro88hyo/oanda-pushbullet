
# encoding: utf-8

class StockChart
  attr_accessor :data

  def initialize
    @data = Array.new
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

  def test()
    #@data = [1,2,3,4,5,6,7,8,9,10]
    #@data = [3585,3325,3310,3455,3360,3465,3575,3575,3440,3635]
    #@data = [460000,457000,452000,470000,461000,456000,456000,441000,413000]
    @data = [123.13,121.74,121.53,121.05,120.75,120.61,121.12,121.06,120.45,121.07,121.45,120.66,119.93,119.82,119.48,119.42,118.87,118.82,119.73,120.02,120.25,119.91,120.00,120.23,120.45,119.89,119.92,119.84,119.71,119.91,120.55,120.06,120.28,120.12,120.53,119.98,119.98,120.55,120.42,120.22,120.66,119.93,119.82,119.48,119.42,118.87,118.82,119.73,120.02,120.25,119.91,120.00,120.23,120.45,119.89,119.92,119.84,119.71,119.91,120.55,120.06,120.28,120.12,120.53,119.98,119.98,120.55,120.42,120.22]

    #p self.SMA()
    #p self.EMA(12)
    #p self.MACD()
    p self.RSI()
  end
end
