require 'yaml'
require 'net/http'

config       = YAML.load(File.read('deploy_config.yml'))

hostname     = config[:hostname]
user         = config[:user]

github_user  = config[:github_user]
github_repo  = config[:github_repo]

ip           = `ruby get_ip_for.rb #{hostname}`.chomp

ssh_command  = "ssh #{user}@#{ip}"
repo_url = "git@github.com:#{github_user}/#{github_repo}.git"

remote_command = "if [ -d #{github_repo} ]; then
  cd #{github_repo}
  git checkout master
  git pull --no-ff origin master
else
  git clone #{repo_url}
fi
"
remote_commands = ["git clone #{repo_url}"]

puts `#{ssh_command} '#{remote_command}'`
