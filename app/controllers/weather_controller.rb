class WeatherController < ApplicationController
  def index
  end

  def fetch_weather
    address = params[:address]
    coordinates = Geocoder.coordinates(address)

    if coordinates
      zip_code = Geocoder.search(address).first.postal_code
      cache_key = "weather_#{zip_code}"

      @weather, @cached = fetch_cached_weather(cache_key)

      unless @weather
        @weather = WeatherService.get_forecast(coordinates)
        cache_weather_data(cache_key, @weather)
        @cached = false
      end
    else
      flash[:error] = 'Invalid address'
      redirect_to root_path
    end
  end

  private

  # Fetch cached weather data and delete if stale
  def fetch_cached_weather(key)
    entry = CacheEntry.find_by(key: key)

    #TODO 30 is the time to live for the cache entry.  It should be defined by env var, not hardcoded.
    if entry && entry.created_at > 30.minutes.ago
      [JSON.parse(entry.value, symbolize_names: true), true]
    else
      entry&.destroy # Delete stale entry if it exists
      [nil, false]
    end
  end

  # Cache weather data
  def cache_weather_data(key, weather_data)
    CacheEntry.create!(key: key, value: weather_data.to_json, created_at: Time.current)
  end
end