require 'pry'
class APIManager

    BASE_URL = "https://api.yelp.com/v3"

    def self.search_businesses()
        url = BASE_URL + "/businesses/search"

        headers = {"Authorization": "Bearer #{API_KEY}"}
        query = {"location": loc, "term": query}
        res = HTTParty.get(url, query: query, headers: headers)

        first_business_id = res["businesses"][0]["id"]
        binding.pry
    end
    APIManager.search_businesses("houston", "art classes")
end