# frozen_string_literal: true

require 'persist'

require './app/init'
require './app/models/session'
require './app/models/task'

module Api
  class ClaimService
    attr_accessor :task

    API_URL = 'https://aqueous-fjord-19834.herokuapp.com/'
    CALIM_TYPES = {
      twitter: {
        follow: 'checkfollow',
        like: 'checktweet',
        retweet: 'checktweet',
        comment: 'checktweet'
      }
    }.freeze

    def initialize(task)
      @task = task
    end

    def call
      platform_claims = CALIM_TYPES[task.platform]

      return 0 if platform_claims.nil? || platform_claims[task.action].nil?

      puts 'Claiming'
      response = connection.get(platform_claims[task.action], {
                                  taskId: task.uuid,
                                  userId: task.session.user_id,
                                  twitteruid: task.twitter_uid,
                                  tweetid: task.tweet_id
                                })

      persist_claimed(response, task.uuid)
      print_response(response)
      calculate_reward(response)
    end

    private

    def calculate_reward(response)
      if task.reward && response_ok(response)
        Integer(task.reward.to_s.split('.').first)
      else
        0
      end
    end

    def persist_claimed(response, task_uuid)
      return unless response.body.include?('task already done') || response.body.include?('fail')

      already_claimed = Persist.new
      already_claimed[task_uuid] = true
      already_claimed
    end

    def print_response(response)
      if response.body.include? 'task already done'
        puts 'Already Done ✅'
      elsif response.body.include? 'fail'
        puts "Failed ❌ ->#{response.body}"
      elsif response_ok(response)
        puts "#{task.reward} sats claimed! 🤑"
      else
        puts "Reponse ->#{response.body}"
      end
    end

    def response_ok(response)
      response.body.include?('ok')
    end

    def connection
      @connection ||= ::Faraday.new(url: API_URL) do |conn|
        conn.request :json
        conn.response :json, parser_options: { symbolize_names: true }
        conn.adapter(:net_http)
      end
    end
  end
end
