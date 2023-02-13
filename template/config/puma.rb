# frozen_string_literal: true

workers ENV.fetch('WEB_CONCURRENCY', 0)
min_threads_count = ENV.fetch('MIN_THREADS', 1)
max_threads_count = ENV.fetch('MAX_THREADS', 8)
threads min_threads_count, max_threads_count

port ENV.fetch('PORT', 9292)

environment ENV.fetch('RACK_ENV', 'development')
