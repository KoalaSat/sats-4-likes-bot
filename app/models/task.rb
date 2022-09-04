# frozen_string_literal: true

require 'faraday'
require 'time'

require './app/init'
require './app/services/platforms/twitter/follow_service'
require './app/services/platforms/twitter/like_service'
require './app/services/platforms/twitter/retweet_service'
require './app/services/platforms/twitter/comment_service'

class Task
  attr_accessor :uuid, :hash, :session

  ACTION_TYPES = {
    twitter: {
      follow: Platforms::Twitter::FollowService,
      retweet: Platforms::Twitter::RetweetService,
      like: Platforms::Twitter::LikeService,
      comment: Platforms::Twitter::CommentService,
      custom: nil
    },
    youtube: {
      subscribe: nil,
      custom: nil
    },
    telegram: {
      telegram: nil,
      custom: nil
    },
    custom: {
      custom: nil
    },
    '1ml': {
      channel: nil,
      custom: nil
    }
  }.freeze

  def initialize(uuid, hash, session)
    @uuid = uuid
    @hash = hash
    @session = session
  end

  def active?
    hash['paid'] && hash['donecount'] < hash['targetcount'] && !taskers.nil?
  end

  def started?
    taskers[session.user_id].nil?
  end

  def pending_unlock?
    return false if !timelock? || hash['timelocktaskers'].nil?

    remaining_time = hash['timelocktaskers'][session.user_id]

    return false if remaining_time.nil?

    Time.now.to_i * 1000 < remaining_time + hash['timelockduration']
  end

  def timelock?
    hash['timelock']
  end

  def platform
    hash['platform'].to_sym
  end

  def action
    hash['type'].to_sym
  end

  def taskers
    hash['taskers']
  end

  def reward
    hash['priceperaction']
  end

  def twitter_uid
    hash['twitteruid']
  end

  def twitter_comment
    hash['description']
  end

  def twitter_name
    hash['link'].split('https://twitter.com/').last&.split('/')&.first&.split('/')&.first
  end

  def tweet_id
    hash['link'].split('https://twitter.com/').last&.split('status/')&.last&.split('?')&.first
  end

  def channel_id
    hash['link'].split('channel/').last&.split('?')&.first
  end

  def run
    platform_actions = ACTION_TYPES[platform]

    if platform_actions.nil? || platform_actions[action].nil?
      puts "Action #{action} not implemented 🧑‍💻"
      return
    end

    platform_icon = '🐦'

    puts "Running for -> #{platform} #{platform_icon}"
    puts "Action -> #{action}"

    platform_actions[action].new(self).call

    true
  end
end
