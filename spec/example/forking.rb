require 'bundler/setup'
require 'forking'

root = File.expand_path(File.dirname(__FILE__))

PID_NAME = ENV["PID_NAME"] || "forking.pid"

f = Forking.new(:name => 'forking', :working_dir => root,
    :log_file => "#{root}/forking.log",
    :pid_file => "#{root}/#{PID_NAME}", :sync_log => true)

3.times do |i|
  f.spawn(:log_file => "#{root}/child#{i}.log", :sync_log => true) do
    $0 = "forking child"
    start_at = Time.now
    loop do
      tm = Time.now
      p "#{tm} - #{tm.to_f} - #{i} - tick"
      sleep 0.1
      return if tm - start_at > 600
    end
  end
end

f.run!