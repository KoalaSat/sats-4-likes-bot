# frozen_string_literal: true

require './app/init'
require './app/models/session'
require './app/services/platforms/twitter/base_service'
require './app/clients/twitter'

module Platforms
  module Twitter
    class LikeService < BaseService
      def call
        puts "Liking 💙 -> #{task.hash['link']}"

        Clients::Twitter.instance.client.favorite(task.tweet_id)
      end
    end
  end
end
