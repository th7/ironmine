require 'yaml'
require 'net/http'

config       = YAML.load(File.read('deploy_config.yml'))
site_config  = YAML.load(File.read(config[:site_config]))

hostname     = config[:hostname]
user         = config[:user]

username     = site_config[:username]
password     = site_config[:password]

check_ip_url = "#{site_config[:domain]}#{site_config[:dns]}/#{hostname}#{config[:check_ip]}"

get_from     = "#{check_ip_url}?user[username]=#{username}&user[password]=#{password}"

ip_response  = Net::HTTP.get_response(URI.parse(get_from))
ip           = ip_response.body

ssh_command  = "ssh #{user}@#{ip}"
remote_commands = ['ls', 'pwd', 'ls']

puts `#{ssh_command} '#{remote_commands.join(' && ')}'`

# Process.join(pid)
