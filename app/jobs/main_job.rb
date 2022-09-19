# frozen_string_literal: true

require 'persist'

require './app/init'
require './app/models/task'
require './app/services/api/get_session_and_tasks_service'
require './app/services/api/claim_service'

module Jobs
  class MainJob
    class << self
      def call
        puts 'START ₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿'

        already_claimed = Persist.new
        data = Api::GetSessionAndTasksService.new.call
        gained = 0
        data[:tasks].each do |task|
          next unless already_claimed[task.uuid] || task.active?

          puts "Run -> #{task.uuid}"
          puts "Started? 🚀 -> #{task.started?}"
          task.run
          if task.pending_unlock?
            puts 'Locked 🔒'
          else
            gained += Api::ClaimService.new(task).call
          end
          puts '₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿'
        end

        puts "You got #{gained} sats! 🤑" if gained.positive?
        puts 'Made with 🐨 by https://getalby.com/p/koalasat'
      end
    end
  end
end
