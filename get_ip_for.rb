require 'net/http'
require 'yaml'
require 'cgi'

site_config  = YAML.load(File.read('tylerhartland_config.yml'))
username     = CGI.escape(site_config[:username])
password     = CGI.escape(site_config[:password])
domain       = site_config[:domain]
dns          = site_config[:dns]
hostname     = ARGV[0]

check_ip_url = "#{domain}#{dns}/#{hostname}/check_ip"
get_from     = "#{check_ip_url}?user[username]=#{username}&user[password]=#{password}"

ip_response  = Net::HTTP.get_response(URI.parse(get_from))
ip           = ip_response.body

puts ip
