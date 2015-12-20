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
    https = Net::HTTP.new(uri.host, uri.port)
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
