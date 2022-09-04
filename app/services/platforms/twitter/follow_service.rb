# frozen_string_literal: true

require './app/init'
require './app/models/session'
require './app/services/platforms/twitter/base_service'
require './app/clients/twitter'

module Platforms
  module Twitter
    class FollowService < BaseService
      def call
        if already_follow?
          puts "Already followed ➕ -> #{task.twitter_name}"
          return
        end

        puts "Following ➕ -> #{task.twitter_name}"
        Clients::Twitter.instance.client.follow(task.twitter_name)
      rescue ::Twitter::Error::NotFound
        nil
      end

      private

      def already_follow?
        source = Clients::Twitter.instance.client.friendship(task.session.user_name,
                                                             task.twitter_name).source

        source.following? || source.attrs[:following_requested]
      end
    end
  end
end
