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
    res = _api_get("v1/accounts")
    p res
    return res
  end

  def getInstruments()
    accountId = self.getAccount()['accounts'][0]['accountId']
    res = _api_get("v1/instruments?accountId=#{accountId}")
    return res
  end

  def getCurrentRate(instrument: 'USD_JPY')
    res = _api_get("v1/prices?instruments=#{instrument}")
    return res
  end

  def getHistoricalRate(instrument: 'USD_JPY', granularity: 'M5', count: 1)
    res = _api_get("v1/candles?instrument=#{instrument}&granularity=#{granularity}&count=#{count}")
    return res
  end

  def _api_get(command)
    uri = URI.parse(@api_endpoint+command)
    
    proxy_env = URI.parse(ENV["http_proxy"])
    proxy_user, proxy_pass = proxy_env.userinfo.split(":")
    
    https = Net::HTTP.new(uri.host, uri.port, proxy_env.host, proxy_env.port, proxy_user, proxy_pass)
    https.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    req['Authorization'] = "Bearer #{@access_token}"

    response = https.request(req)
    return JSON.parse(response.body)
  end
end
