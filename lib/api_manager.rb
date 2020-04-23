class APIManager
    
    BASE_URL = "https://api.yelp.com/v3"
    
    

    def self.search_businesses(loc, query, pagenum=1, limit=20)
        business_search_url = BASE_URL + "/businesses/search" + "?limit=#{limit}&offset=#{(pagenum-1)*limit}"
        headers = {"Authorization": "Bearer #{ENV['API_KEY']}"}
        query = {"location": loc, "term": query}
        res = HTTParty.get(business_search_url, query: query, headers: headers)
        res["businesses"]
           
    end

    
    def self.search_reviews(business_id)
        reviews_search_url = BASE_URL + "/businesses/#{business_id}/reviews"
        headers = {"Authorization": "Bearer #{ENV['API_KEY']}"}  
        res = HTTParty.get(reviews_search_url, {headers: headers})

        b = Business.all.detect do |b|
            b.id == business_id
        end

        res["reviews"].each do |review_hash| 
            Reviews.new(b, review_hash) 
        end
    end   
end


