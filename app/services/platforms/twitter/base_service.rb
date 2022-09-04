# frozen_string_literal: true

require './app/init'

module Platforms
  module Twitter
    class BaseService
      attr_reader :task

      def initialize(task)
        @task = task
      end
    end
  end
end
