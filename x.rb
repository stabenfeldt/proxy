require "httparty"
require "pp"


base_uri = "https://esi.evetech.net/latest/universe/names/?datasource=tranquility"
options = { 
    :body =>  "[ 95465499, 30000142]"
}

results = HTTParty.post(base_uri, options)
pp results



