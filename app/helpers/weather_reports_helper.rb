require 'uri'
require 'net/http'

module WeatherReportsHelper

  API_KEY = "vBtwB5IcpkdfW1Coc2xDRug8UHP0Z4du"

  def get_daily_weather(zip_code)
    url = URI("https://api.tomorrow.io/v4/weather/forecast?location=#{zip_code}&timesteps=daily&apikey=#{API_KEY}")

    res = get_api_response(url)
    daily_timelines = res["timelines"]["daily"].map do |day| 
      {
        "day" => day["time"],
        "temperatureMax" => day["values"]["temperatureMax"],
        "temperatureMin" => day["values"]["temperatureMin"]
      }
    end

    {"daily_timelines" => daily_timelines}
  end

  def get_weather_info(zip_code)
    url = URI("https://api.tomorrow.io/v4/weather/realtime?location=#{zip_code}&apikey=#{API_KEY}")
    get_api_response(url).merge(get_daily_weather(zip_code))
  end

  def get_api_response(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    response = http.request(request)
    response_body = JSON.parse(response.read_body)
    raise response_body["message"] if response_body["code"] == 429001
    response_body
  end

  def to_datetime_format(datetime)
    DateTime.parse(datetime).strftime( "%a, %b %d")
  end
end
