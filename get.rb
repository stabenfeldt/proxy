require "httparty"
require "pp"


@orders_url      = "https://esi.evetech.net/latest/markets/10000002/orders/?datasource=tranquility&order_type=all&page=1"
@lookup_name_url = "https://esi.evetech.net/latest/universe/names/?datasource=tranquility"

def get_orders
  HTTParty.get(@orders_url)
end

def extract_key(data, key)
  data.map { |t| t[key] }
end

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
pp get_names(type_ids)

