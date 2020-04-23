class Reviews
    attr_accessor :id, :text, :url, :rating, :time_created, :user
    @@all = []

    def initialize(a_business = nil, review_hash)
        self.business=(a_business) if a_business != nil
        review_hash.each do |key, value|
            self.send("#{key}=", value)
        end
        save
    end

    def business
        @business
    end

    def business=(business)
        @business = business
        business.add_review(self)
    end

    def save 
        @@all << self
    end

    def self.all
        @@all
    end

    def self.clear
        all.clear
    end

    def self.get_reviews_from_business(business)
        self.all.detect do |i|
            i.business == business
        end
    end 

end