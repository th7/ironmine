require 'yaml'
require 'net/http'

config       = YAML.load(File.read('deploy_config.yml'))
site_config  = YAML.load(File.read(config[:site_config]))

hostname     = config[:hostname]
user         = config[:user]

username     = site_config[:username]
password     = site_config[:password]

github_user  = config[:github_user]
github_repo  = config[:github_repo]

check_ip_url = "#{site_config[:domain]}#{site_config[:dns]}/#{hostname}#{config[:check_ip]}"

get_from     = "#{check_ip_url}?user[username]=#{username}&user[password]=#{password}"

ip_response  = Net::HTTP.get_response(URI.parse(get_from))
ip           = ip_response.body

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

# Process.join(pid)
