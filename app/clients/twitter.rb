# frozen_string_literal: true

require 'singleton'
require 'twitter'

require './app/init'

module Clients
  class Twitter
    include Singleton

    attr_accessor :client, :user_timeline

    def client
      @client ||= ::Twitter::REST::Client.new do |config|
        config.consumer_key        = TWITTER_CONSUMER_KEY
        config.consumer_secret     = TWITTER_CONSUMER_SECRET
        config.access_token        = TWITTER_ACCESS_TOKEN
        config.access_token_secret = TWITTER_ACCESS_SECRET
      end
    end

    def user_timeline
      @user_timeline ||= client.user_timeline(client.user, count: 100)
    end
  end
end
