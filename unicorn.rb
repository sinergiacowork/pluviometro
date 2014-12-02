# Start unicorn with: `bundle exec unicorn -E production -c config/unicorn.rb`
UNICORN_WORKERS = Integer(ENV['UNICORN_WORKERS'] || 2)
UNICORN_TIMEOUT = Integer(ENV['UNICORN_TIMEOUT'] || 15)

worker_processes UNICORN_WORKERS
timeout UNICORN_TIMEOUT
