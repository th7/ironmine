begin
  Process.daemon(true)
  file_path = ARGV[0]
  File.open("#{file_path}.pid", 'w') { |f| f.write(Process.pid) }
  $stdout.reopen("#{file_path}.log", 'a')
  $stderr.reopen("#{file_path}.log", 'a')
  load(file_path)
ensure
  File.delete("#{file_path}.pid")
end
