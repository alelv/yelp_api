class APIManager
    #require 'pry'
    BASE_URL = "https://api.yelp.com/v3"
    

    def self.search_businesses(loc, query)
        url = BASE_URL + "/businesses/search"

        headers = {"Authorization": "Bearer #{ENV['API_KEY']}"}
        query = {"location": loc, "term": query}
        res = HTTParty.get(url, query: query, headers: headers)
        Business_getter.mass_create_from_api(res["businesses"])
        
        #first_business_id = res["businesses"][0]["id"]
        #first_business_name = res["businesses"][0]
        #url2 = BASE_URL + "businesses/#{first_business_id}/reviews"
        #res2 = HTTParty.get(url2, {headers: headers})
        #binding.pry
    end
   
end