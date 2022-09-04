# frozen_string_literal: true

require './app/init'
require './app/models/session'
require './app/services/platforms/twitter/base_service'
require './app/clients/twitter'

module Platforms
  module Twitter
    class RetweetService < BaseService
      def call
        puts "Retweeting 🔃 -> #{task.hash['link']}"

        Clients::Twitter.instance.client.retweet(task.tweet_id)
      end
    end
  end
end
