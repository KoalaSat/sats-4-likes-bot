# frozen_string_literal: true

require 'faye/websocket'
require 'eventmachine'
require 'json'

require './app/init'
require './app/models/session'
require './app/models/task'

module Api
  class GetSessionAndTasksService
    WEBSOCKET_URL = "wss://#{FIREBASE_WENSOCKET_SUBDOMAIN}.firebaseio.com/.ws?v=5&ns=yunik2-1014b"
    GOOGLE_URL = 'https://securetoken.googleapis.com/'

    def initialize
      @tasks_list_json = ''
      @session = nil
    end

    def call
      EM.run do
        incoming_tasks_list = false

        websockets.on :open do |_event|
          # rubocop:disable Layout/LineLength
          websockets.send("{\"t\":\"d\",\"d\":{\"r\":1,\"a\":\"auth\",\"b\":{\"cred\":\"#{access_token}\"}}}")
          # rubocop:enable Layout/LineLength
        end

        websockets.on :message do |event|
          if event.data.include?('auth') && @session.nil?
            generate_session(event.data)
            request_list
          elsif event.data.include?('satsforlikes')
            incoming_tasks_list = true
          elsif event.data.include?('no_index')
            incoming_tasks_list = false
            websockets.close
          end

          @tasks_list_json += event.data if incoming_tasks_list
        end

        websockets.on :close do |_event|
          EM.stop
        end
      end

      {
        session: @session,
        tasks: generate_tasks
      }
    end

    def websockets
      @websockets ||= Faye::WebSocket::Client.new(WEBSOCKET_URL)
    end

    def request_list
      # rubocop:disable Performance/StringIdentifierArgument
      # rubocop:disable Layout/LineLength
      websockets.send("{\"t\":\"d\",\"d\":{\"r\":2,\"a\":\"n\",\"b\":{\"p\":\"/user-info/#{@session.user_id}/settings/hidefilter\"}}}")
      websockets.send("{\"t\":\"d\",\"d\":{\"r\":3,\"a\":\"q\",\"b\":{\"p\":\"/user-info/#{@session.user_id}/settings/sorters\",\"h\":\"\"}}}")
      websockets.send("{\"t\":\"d\",\"d\":{\"r\":5,\"a\":\"q\",\"b\":{\"p\":\"/user-info/#{@session.user_id}/settings/hiddentasks\",\"h\":\"\"}}}")
      sleep 1
      websockets.send('{"t":"d","d":{"r":7,"a":"q","b":{"p":"/satsforlikes","q":{"sp":true,"ep":true,"i":"paid"},"t":1,"h":""}}}')
      # rubocop:enable Performance/StringIdentifierArgument
      # rubocop:enable Layout/LineLength
    end

    def generate_data_json(json)
      json.nil? ? {} : JSON.parse(json)['d']['b']['d']
    end

    def generate_tasks
      json = generate_data_json(@tasks_list_json)

      json.keys.map do |uuid|
        Task.new(uuid, json[uuid], @session)
      end
    end

    def generate_session(session_json)
      @session = Session.new(generate_data_json(session_json))
    end

    def access_token
      response = connection.post("v1/token?key=#{TOKEN_KEY}", {
                                   grant_type: 'refresh_token',
                                   refresh_token: REFRESH_TOKEN
                                 })
      response.body[:access_token]
    end

    def connection
      @connection ||= ::Faraday.new(url: GOOGLE_URL) do |conn|
        conn.request :json
        conn.response :json, parser_options: { symbolize_names: true }
        conn.adapter(:net_http)
      end
    end
  end
end
