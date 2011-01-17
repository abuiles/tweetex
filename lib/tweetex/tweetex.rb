require 'rubygems'
require 'twitter'
require 'net/http'
require 'uri'
require 'json'

module Tweetex
  class TweetExchange
    def initialize(from, to, consumer_key, consumer_secret, oauth_token, oauth_token_secret)
      ['from', 'to', 'consumer_key', 'consumer_secret', 'oauth_token', 'oauth_token_secret'].each do |var|
        instance_variable_set(:"@#{var}", (eval var))
      end
    end

    attr_accessor :consumer_key, :consumer_secret, :from, :oauth_token, :oauth_token_secret, :to

    def post
      exchange = grab_exchange_rate
      if exchange
        twitter  = set_twitter_connection
        message = "#{Time.now.strftime("%m/%d/%Y at %I:%M%p")}: exchange rate  from #{@from} to #{@to} is: #{exchange}"
        client = Twitter::Client.new
        client.update(message)
      end
    end

    def grab_exchange_rate
      uri = URI.parse("http://xurrency.com/api/#{@from}/#{@to}/1")
      response = Net::HTTP.get_response(uri)
      return false unless response.code == "200"
      hash = JSON.parse(response.body)
      return false unless hash["code"] == 0
      hash["result"]["value"]
    end

    def set_twitter_connection
      Twitter.configure do |config|
        config.consumer_key = @consumer_key
        config.consumer_secret = @consumer_secret
        config.oauth_token = @oauth_token
        config.oauth_token_secret = @oauth_token_secret
      end
    end
  end
end
