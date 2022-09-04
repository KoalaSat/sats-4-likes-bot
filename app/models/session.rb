# frozen_string_literal: true

require './app/init'

class Session
  attr_accessor :hash, :user_id

  def initialize(hash)
    @hash = hash
  end

  def user_id
    hash['auth']['user_id']
  end

  def user_name
    hash['auth']['name']
  end

  def twitter_id
    hash['auth']['token']['firebase']['identities']['twitter.com'].first
  end

  def twitter_timeline
    client.user_timeline(client.user, count: 40)
  end
end
