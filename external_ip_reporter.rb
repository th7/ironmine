require 'yaml'
require 'net/http'
require 'logger'

logger = Logger.new(STDOUT)

config = YAML.load(File.read('external_ip_reporter_config.yml'))
site_config = YAML.load(File.read(config[:site_config]))

username  = site_config[:username]
password  = site_config[:password]
dns_url = "#{site_config[:domain]}#{site_config[:dns]}"
url       = config[:url]
get_from  = "#{dns_url}?user[username]=#{username}&user[password]=#{password}"

loop do
  fresh_ip_response = Net::HTTP.get_response(URI.parse(get_from))

  if fresh_ip_response.code =='200'
    fresh_ip = fresh_ip_response.body
  else
    logger.warn("External IP check GET from #{dns_url.inspect} failed.")
    logger.warn(fresh_ip_response.inspect)
  end

  unless fresh_ip == @ip
    logger.info("IP changed from #{@ip.inspect} to #{fresh_ip.inspect}")


    @ip = fresh_ip
    params = {
      'user[username]' => username,
      'user[password]' => password,
      'dns[url]' => url,
      'dns[ip]' => @ip
    }

    update_response = Net::HTTP.post_form(URI.parse(dns_url), params)

    if update_response.code =='200'
      logger.info("IP updated. Successful POST to #{dns_url.inspect} with url/key #{url.inspect} and ip #{@ip.inspect}")
    else
      logger.warn("IP update to #{dns_url.inspect} failed with key #{url.inspect} and ip #{@ip.inspect}")
      logger.warn(update_response.inspect)
    end
  end

  sleep 60
end
