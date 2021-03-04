require 'net/http'
require 'json'
require "httparty"
require "pp"


@orders_url      = "https://esi.evetech.net/latest/markets/10000002/orders/?datasource=tranquility&order_type=all&page=1"
@universe_url    = "https://esi.evetech.net/latest/universe/names/?datasource=tranquility"
@lookup_name_url = "https://esi.evetech.net/latest/universe/names/?datasource=tranquility"


# curl -X GET "https://esi.evetech.net/latest/markets/10000002/orders/?datasource=tranquility&order_type=all&page=1" 
def get_orders
	uri = URI(@orders_url)
	Net::HTTP.start(uri.host, uri.port,
	  :use_ssl => uri.scheme == 'https') do |http|
	  request = Net::HTTP::Get.new uri
	
	  response = http.request request # Net::HTTPResponse object
    orders =  JSON.parse( response.read_body )
    pp orders.first["type_id"]
    pp "===="
    type_ids = orders.map { |t| t["type_id"] }
    pp type_ids
    # pp type_ids.first["type_id"]

	end
end

# Returns product name.
#  curl -X POST "https://esi.evetech.net/latest/universe/names/?datasource=tranquility"   -d "[ 95465499, 30000142]"
def	fetch_name(product_id)
  puts "==========="
  puts "in fetch_name"
  puts "==========="
	uri = URI("https://esi.evetech.net/latest/universe/names/?datasource=tranquility")

  params = [ 95465499, 30000142]
	Net::HTTP.start(uri.host, uri.port,
	  :use_ssl => uri.scheme == 'https') do |http|
     request = Net::HTTP.post_form(uri,  params)
		 request.read_body
	end
end


# First, fetch all the products
orders_json = get_orders
#$products = JSON.parse(products_json)

# Print the product name of the 10 first products.
# n = 0
# products.each do |product|
#   # puts product
#   while n < 1
#     type_id = product["type_id"]
#     name = fetch_name(type_id)
#     puts "one name is #{name}"
#     n += 1
#   end
# end
# [{"duration":90,"is_buy_order":false,"issued":"2021-02-15T20:28:58Z","location_id":60003760,"min_volume":1,"order_id":5926551566,"price":392.2,"range":"region","system_id":30000142,"type_id":2400,"volume_remain":349627,"volume_total":349627},{"duration":90,"is_buy_order":false,"issued":"2021-02-27T11:37:03Z","location_id":60003760,"min_volume":1,"order_id":5937037329,"price":45810.0,"range":"region","system_id":30000142,"type_id":20424,"volume_remain":1914,"volume_total":1914},{"duration":90,"is_buy_order":false,"issued":"2021-02-13T19:44:45Z","location_id":60012667,"min_volume":1,"order_id":5924454426,"price":19990.0,"range":"region","system_id":30000180,"type_id":21857,"volume_remain":8,"volume_total":14},{"duration":90,"is_buy_order":false,"issued":"2021-01-30T20:50:37Z","location_id":60003760,"min_volume":1,"order_id":5911871517,"price":290000.0,"range":"region","system_id":30000142,"type_id":31587,"volume_remain":8,"volume_total":9},{"duration":90,"is_buy_order":false,"issued":"2021-02-28T11:00:18Z","location_id":60003760,"min_volume":1,"order_id":5938085918,"price":283.8,"range":"region","system_id":30000142,"type_id":3645,"volume_remain":290,"volume_total":290},{"duration":90,"is_buy_order":false,"issued":"2021-03-04T10:48:17Z","location_id":60003760,"min_volume":1,"order_id":5934940194,"price":49160000.0,"range":"region","system_id":30000142,"type_id":46999,"volume_remain":1,"volume_total":1},{"duration":90,"is_buy_order":false,"issued":"2020-12-27T10:37:28Z","location_id":60003760,"min_volume":1,"order_id":5882511399,"price":170800.0,"range":"region","system_id":30000142,"type_id":43699,"volume_remain":58,"volume_total":79},{"duration":90,"is_buy_order":false,"issued":"2021-03-04T01:26:08Z","location_id":60003760,"min_volume":1,"order_id":5941231657,"price":2777000.0,"range":"region","system_id":30000142,"type_id":2913,"volume_remain":4,"volume_total":4},{"duration":90,"is_buy_order":false,"issued":"2021-03-04T01:26:08Z","location_id":60003760,"min_volume":1,"order_id":5941231659,"price":108400.0,"range":"region","system_id":30000142,"type_id":9209,"volume_remain":1,"volume_total":1},{"duration":90,"is_buy_order":false,"issued":"2021-03-04T01:26:08Z","location_id":60003760,"min_volume":1,"order_id":5941231660,"price
