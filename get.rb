require 'net/http'
require 'json'
require "httparty"
require "pp"


@orders_url      = "https://esi.evetech.net/latest/markets/10000002/orders/?datasource=tranquility&order_type=all&page=1"
@lookup_name_url = "https://esi.evetech.net/latest/universe/names/?datasource=tranquility"


# curl -X GET "https://esi.evetech.net/latest/markets/10000002/orders/?datasource=tranquility&order_type=all&page=1" 
def get_orders
	uri = URI(@orders_url)
	Net::HTTP.start(uri.host, uri.port,
	  :use_ssl => uri.scheme == 'https') do |http|
	  request = Net::HTTP::Get.new uri
	
	  response = http.request request # Net::HTTPResponse object
    JSON.parse( response.read_body )
	end
end

def extract_key(data, key)
    data.map { |t| t[key] }
end

# Returns product name.
def get_names(type_ids)
  # Limit the set to 10 
  type_ids = type_ids.shift(10)

  options = { 
    :body =>  type_ids.to_s
  }
  
  results = HTTParty.post(@lookup_name_url, options)
  extract_key(results, "name")
end




# First, fetch all the orders
orders = get_orders

# Extract the type_ids from the result
type_ids = extract_key(orders, "type_id")

# Fetch and print names for the type_ids
puts get_names(type_ids)

