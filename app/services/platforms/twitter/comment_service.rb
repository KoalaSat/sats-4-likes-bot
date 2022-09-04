# frozen_string_literal: true

require './app/init'
require './app/models/session'
require './app/services/platforms/twitter/base_service'
require './app/clients/twitter'

module Platforms
  module Twitter
    class CommentService < BaseService
      def call
        if already_commented?
          puts "Already commented 💬 -> #{task.twitter_name}"
          return
        end
        puts "Commenting 💬 -> #{task.hash['link']}"

        Clients::Twitter.instance.client.update(generate_comment,
                                                in_reply_to_status_id: task.tweet_id.to_s)
      end

      private

      def generate_comment
        "@#{task.twitter_name} #{task.twitter_comment}"
      end

      def already_commented?
        Clients::Twitter.instance.user_timeline.any? do |tweet|
          tweet.full_text.include? task.twitter_comment
        end
      end
    end
  end
end
