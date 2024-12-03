Rails.application.routes.draw do
  root 'weather#index'
  get 'fetch_weather', to: 'weather#fetch_weather'
end
