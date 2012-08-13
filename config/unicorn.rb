worker_processes 6
preload_app true
timeout 30
listen 3001
#rails_root  = `pwd`.gsub("\n", "")
rails_root = "/home/aceim/aceim"
pid         "#{rails_root}/tmp/pids/unicorn.pid"
#stderr_path "#{rails_root}/log/unicorn.log"
#stdout_path "#{rails_root}/log/unicorn.log"

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end
