#!/bin/zsh

# Exit on error
set -e

echo "Updating Gemfile with required gems..."
cat <<EOL >> Gemfile

# Gems for weather application
gem 'httparty'
gem 'redis-rails', '~> 5.0'
gem 'geocoder'

# Compatibility gems
gem 'sqlite3', '< 1.6' # For SQLite compatibility with Ruby 2.7
gem 'sassc-rails', '>= 2.1.0'
gem 'warning', '>= 1.3.0'
EOL

echo "Installing gems..."
bundle install

echo "Creating WeatherController..."
cat <<EOL > app/controllers/weather_controller.rb
class WeatherController < ApplicationController
  def index
  end

  def fetch_weather
    address = params[:address]
    coordinates = Geocoder.coordinates(address)
    if coordinates
      zip_code = Geocoder.search(address).first.postal_code
      cache_key = "weather_#{zip_code}"
      if Rails.cache.exist?(cache_key)
        @weather = Rails.cache.read(cache_key)
        @cached = true
      else
        @weather = WeatherService.get_forecast(coordinates)
        Rails.cache.write(cache_key, @weather)
        @cached = false
      end
    else
      flash[:error] = 'Invalid address'
      redirect_to root_path
    end
  end
end
EOL

echo "Creating WeatherService..."
mkdir -p app/services
cat <<EOL > app/services/weather_service.rb
class WeatherService
  include HTTParty
  base_uri 'api.openweathermap.org/data/2.5'

  def self.get_forecast(coordinates)
    api_key = ENV['WEATHER_API_KEY']
    response = get("/weather", query: {
      lat: coordinates[0],
      lon: coordinates[1],
      appid: api_key,
      units: 'metric'
    })

    if response.success?
      {
        current_temp: response['main']['temp'],
        high: response['main']['temp_max'],
        low: response['main']['temp_min'],
        description: response['weather'][0]['description']
      }
    else
      { error: response['message'] }
    end
  end
end
EOL

echo "Creating views for weather..."
mkdir -p app/views/weather
cat <<EOL > app/views/weather/index.html.erb
<%= form_with url: fetch_weather_path, method: :get do %>
  <div>
    <%= label_tag :address, "Enter Address" %>
    <%= text_field_tag :address %>
  </div>
  <%= submit_tag "Get Forecast" %>
<% end %>
EOL

cat <<EOL > app/views/weather/fetch_weather.html.erb
<% if @weather[:error].present? %>
  <p>Error: <%= @weather[:error] %></p>
<% else %>
  <p>Current Temperature: <%= @weather[:current_temp] %>°C</p>
  <p>High: <%= @weather[:high] %>°C, Low: <%= @weather[:low] %>°C</p>
  <p>Description: <%= @weather[:description] %></p>
  <p>Result from Cache: <%= @cached ? 'Yes' : 'No' %></p>
<% end %>
EOL

echo "Updating routes..."
cat <<EOL > config/routes.rb
Rails.application.routes.draw do
  root 'weather#index'
  get 'fetch_weather', to: 'weather#fetch_weather'
end
EOL

echo "Configuring caching with Redis..."
cat <<EOL >> config/application.rb

    # Redis caching configuration
    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 30.minutes }
EOL

echo "Suppressing Ruby 2.7 warnings..."
cat <<EOL >> config/application.rb

    # Suppress Ruby 2.7 warnings
    require 'warning'
    Warning.ignore(/already initialized constant/)
    Warning.ignore(/Using the last argument as keyword parameters is deprecated/)
EOL

echo "All set! Your Rails application is ready with weather forecast functionality."