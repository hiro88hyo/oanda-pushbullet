# encoding: utf-8
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

class OandaClient
  attr_reader :access_token, :api_endpoint
  def initialize(access_token)
    @api_endpoint = 'https://api-fxpractice.oanda.com/'
    @access_token = access_token
  end

  def getAccount()
    res = _api_request("v1/accounts")
    p res
  end

  def getCurrentRate(instrument: 'USD_JPY')
    res = _api_request("v1/prices?instruments=#{instrument}")
    p res
  end

  def getHistoricalRate(instrument: 'USD_JPY', granularity: 'M5', count: 1)
    res = _api_request("v1/candles?instrument=#{instrument}&granularity=#{granularity}&count=#{count}")
    p res
  end

  def _api_request(command)
    uri = URI.parse(@api_endpoint+command)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    req['Authorization'] = "Bearer #{@access_token}"

    response = https.request(req)
    return JSON.parse(response.body)
  end
end
