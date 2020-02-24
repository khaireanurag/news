require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "4a7b97001aa853a7b13ddd144eb533da"


get "/" do
  # show a view that asks for the location
  view "ask"


end

get "/news" do
  # do everything else
    @Loc_Display = params["location"]
    results = Geocoder.search(params["location"])
    @lat_long = results.first.coordinates

@forecast = ForecastIO.forecast(@lat_long[0],@lat_long[1]).to_hash


@current_temperature = @forecast["currently"]["temperature"]
@current_summary = @forecast["currently"]["summary"]
@tom_temp_high = @forecast["daily"]["data"][0]["temperatureHigh"]
@tom_summary = @forecast["daily"]["data"][0]["summary"]
@dayafter_temp_high = @forecast["daily"]["data"][1]["temperatureHigh"]
@dayafter_summary = @forecast["daily"]["data"][1]["summary"]


url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=0d11e8ca5fec4d41868a8f81416f208f"
news = HTTParty.get(url).parsed_response.to_hash
# news is now a Hash you can pretty print (pp) and parse for your output

puts news["articles"][1]["title"]

@headline = Array.new
@description = Array.new
@url = Array.new

for content in news["articles"]
@headline << content["title"]
@description << content["description"]
@url << content["url"]
end

view "display"

end