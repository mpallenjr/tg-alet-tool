require 'telegram/bot'
require 'net/http'
require 'uri'
require 'json'
require 'dotenv/load'

def send_message(message)
  Telegram::Bot::Client.run(ENV['TG_API_TOKEN']) do |bot|
    bot.api.send_message(chat_id: ENV['MY_TG_ID'], text: message)
  end
end


def get_data
  begin
    success = 0
    error = 0
    uri = URI.parse(ENV['URI'])
    while true
      request = Net::HTTP::Get.new(uri)

      req_options = {
        use_ssl: uri.scheme == "https"
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      if JSON.parse(response.body)['data']['children'].first['data']['title'].include?("[WTS]")
        puts JSON.parse(response.body)['data']['children'].first['data']['title'] # title
        puts JSON.parse(response.body)['data']['children'].first['data']['author'] # author
        puts JSON.parse(response.body)['data']['children'].first['data']['author_flair_text'] # trade count
        puts "#{Time.at(JSON.parse(response.body)['data']['children'].first['data']['created_utc']).strftime('%I:%M:%S %p  %D')}" # time created
        puts JSON.parse(response.body)['data']['children'].first['data']['selftext'] # trade count
        puts JSON.parse(response.body)['data']['children'].first['data']['url'] # trade count
        puts "----------------------------------- #{success} -----------------------------------"
        success += 1
        send_message("#{JSON.parse(response.body)['data']['children'].first['data']['title']} \n\n#{JSON.parse(response.body)['data']['children'].first['data']['author']} \n\n#{JSON.parse(response.body)['data']['children'].first['data']['author_flair_text']} \n\n#{Time.at(JSON.parse(response.body)['data']['children'].first['data']['created_utc']).strftime('%I:%M:%S %p  %D')} \n\n#{JSON.parse(response.body)['data']['children'].first['data']['selftext']} \n\n#{JSON.parse(response.body)['data']['children'].first['data']['url']}")
      end
      sleep(60)
    end
  rescue => e
    puts "Error: #{e} ----------------------------------- #{error} -----------------------------------"
    error += 1
    get_data
  end
end

get_data
