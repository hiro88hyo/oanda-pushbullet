# encoding: utf-8
require 'net/http'
require 'uri'
require 'json'

class PushbulletClient
  attr_reader :pb_endpoint, :access_token
  def initialize(access_token)
    @pb_endpoint = 'https://api.pushbullet.com/v2/pushes'
    @access_token = access_token
  end

  def push_note(title, body)
    request(title, body)
  end

  def request(title, body)
    uri = URI.parse(@pb_endpoint)

    if ENV["http_proxy"]
      proxy_env = URI.parse(ENV["http_proxy"])
      proxy_user, proxy_pass = proxy_env.userinfo.split(":")
    end

    if proxy_env
      https = Net::HTTP.new(uri.host, uri.port, proxy_env.host, proxy_env.port, proxy_user, proxy_pass)
    else
      https = Net::HTTP.new(uri.host, uri.port)
    end

    https.use_ssl = true

    req = Net::HTTP::Post.new(uri.request_uri)
    req['Content-Type'] = 'application/json'
    req['Access-Token'] = @access_token
    payload = {
      "type" => "note",
      "title" => title,
      "body" => body
    }.to_json
    req.body = payload
    res = https.request(req)
  end
end
