Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "weather_reports#weather_report"
  get "/weather_report" => "weather_reports#weather_report"
end
