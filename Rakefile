# frozen_string_literal: true

require './app/jobs/main_job'

desc 'runs the main job'
task :run do
  Jobs::MainJob.call
end

desc 'prints a signal'
task :check do
  puts 'Still Alive'
end
