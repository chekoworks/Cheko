workers 2

threads 1, 6

app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

port        ENV.fetch("PORT") { 5000 }

rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

bind "unix://#{shared_dir}/sockets/puma.sock"

stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

daemonize true

pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"