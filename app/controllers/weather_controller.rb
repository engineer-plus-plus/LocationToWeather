class WeatherController < ApplicationController
  def index
  end


  def cache_available?
    begin
      test_key = "cache_test_key"
      Rails.cache.write(test_key, "test_value", expires_in: 1.minute)
      cached_value = Rails.cache.read(test_key)
      Rails.cache.delete(test_key)
      cached_value == "test_value"
    rescue StandardError => e
      logger.error "Cache availability check failed: #{e.message}"
      false
      raise e
    end
  end


  def fetch_weather

    address = params[:address]
    coordinates = Geocoder.coordinates(address)
    logger.debug(address)
    logger.debug(coordinates)
    if coordinates
      zip_code = Geocoder.search(address).first.postal_code
      logger.debug(zip_code)
      cache_key = "weather_#{zip_code}"
      logger.debug(cache_key)
      if Rails.cache.exist?(cache_key)
        logger.debug("found")
        @weather = Rails.cache.read(cache_key)
        @cached = true
      else
        logger.debug("writing cachekey")
        logger.debug(cache_key)
        @weather = WeatherService.get_forecast(coordinates)
        Rails.cache.write(cache_key, @weather)
        if !Rails.cache.exist?(cache_key)
          raise "Cache sanity check failed"
        end
        @cached = false
      end
    else
      flash[:error] = 'Invalid address'
      redirect_to root_path
    end
  end
end
