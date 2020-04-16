class Business_getter
    attr_accessor :categories, :coordinates, :display_phone, :distance, :id, :alias, :image_url, :is_closed, :location, :name, :phone, :price, :rating, :review_count, :url, :transactions
    @@all = []

    def initialize(business_hash)
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

end