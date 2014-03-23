begin
  Process.daemon(true)
  file_path = ARGV[0]
  pid_file = File.new("#{file_path}.pid", 'w')
  $stdout.reopen("#{file_path}.log", 'a')
  $stderr.reopen("#{file_path}.log", 'a')
  pid_file.write Process.pid
  system("/usr/env/ruby #{file_path}")
ensure
  File.delete(pid_file)
end
