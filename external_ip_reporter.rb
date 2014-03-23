#! usr/bin/env ruby
require 'yaml'
require 'net/http'

config = YAML.load(File.read('external_ip_reporter_config.yml'))

username  = config[:username]
password  = config[:password]
report_to = config[:report_to]
url       = config[:url]
get_from  = "#{report_to}?user[username]=#{username}&user[password]=#{password}"

loop do
  ip = Net::HTTP.get(URI.parse(get_from))

  unless ip == @ip
    @ip = ip
    params = {
      'user[username]' => username,
      'user[password]' => password,
      'dns[url]' => url,
      'dns[ip]' => ip
    }

    p = Net::HTTP.post_form(URI.parse(report_to), params)
  end

  sleep 60
end
