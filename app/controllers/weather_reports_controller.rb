class WeatherReportsController < ApplicationController
  include WeatherReportsHelper

  def weather_report
    @zip_code = params[:zip_code]
    cache_key = ["weather_report", @zip_code]
    # debugger
    begin
      if @zip_code.present?
        @weather_report = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
          get_weather_info(@zip_code)
        end
        if Rails.cache.instance_variable_get(:@data)
          expires_at = Time.at(Rails.cache.instance_variable_get(:@data)["weather_report/#{@zip_code}"].expires_at)
          @cached_at = (1800 - (expires_at - Time.now))/60
          @next_update = (expires_at - Time.now)/60
        end
      else
        Rails.cache.clear
      end
    rescue => e
      @error = e.message
    end
  end
end
