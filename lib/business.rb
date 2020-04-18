class Business
    attr_accessor :categories, :coordinates, :display_phone, :distance, :id, :alias, :image_url, :is_closed, :location, :name, :phone, :price, :rating, :review_count, :url, :transactions
    @@all = []

    def initialize(business_hash)
        @reviews = []
        business_hash.each do |key, value|
            self.send("#{key}=", value)
        end
        save
    end

    def self.mass_create_from_api(businesses_array)
        businesses_array.each do |business_hash|
            created_business = self.new(business_hash)    
        end
    end

    def save 
        @@all << self
    end

    def self.all
        @@all
    end

    def add_review(review_instance)
        if review_instance.business == nil
            review_instance.business = self
        end

        if @reviews.include?(review_instance) == false
            @reviews << review_instance
        end
    end

    def reviews
        @reviews
        # Reviews.get_reviews_from_business(self)
    end
end



# def create_and_add_reviews(review_hash)
#     review = Review.new(review_hash)
#     review.business = self
#     @reviews << review 
# end