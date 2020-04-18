class APIManager
    
    BASE_URL = "https://api.yelp.com/v3"
    
    

    def self.search_businesses(loc, query)
        business_search_url = BASE_URL + "/businesses/search"
        headers = {"Authorization": "Bearer #{ENV['API_KEY']}"}
        query = {"location": loc, "term": query}
        res = HTTParty.get(business_search_url, query: query, headers: headers)
        Business.mass_create_from_api(res["businesses"])
        
        # first_business_id = res["businesses"][0]["id"]
        # first_business_name = res["businesses"][0]
        # url2 = BASE_URL + "businesses/#{first_business_id}/reviews"
        # res2 = HTTParty.get(url2, {headers: headers})
        #binding.pry
    end

    def self.search_reviews(business_id)
        #id ="uoVIBy_2Taprsc7-no1XMA"
        #id = business_id
        reviews_search_url = BASE_URL + "/businesses/#{business_id}/reviews"
        headers = {"Authorization": "Bearer #{ENV['API_KEY']}"}  
        res = HTTParty.get(reviews_search_url, {headers: headers})

        b = Business.all.detect do |b|
            b.id == business_id
        end

        res["reviews"].each do |review_hash| 
            Reviews.new(b, review_hash) 
        end


        #Reviews.mass_create_from_api(res["reviews"])
        #res["reviews"] returns an array of hashes and reviews
        #res["reviews"][0]["text"] return the review for the first place
        
        #binding.pry
    end

    def self.populate_business_reviews(array)

    end
    
   
end