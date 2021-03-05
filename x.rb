require "httparty"
require "pp"


base_uri = "https://esi.evetech.net/latest/universe/names/?datasource=tranquility"
options = { 
    :body =>  "[ 95465499, 30000142]"
}

results = HTTParty.post(base_uri, options)
pp results


@orders_url      = "https://esi.evetech.net/latest/markets/10000002/orders/?datasource=tranquility&order_type=all&page=1"
results = HTTParty.get(@orders_url)
pp results

