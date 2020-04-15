class Business_getter
    attr_accessor :name, :id, :url
    @@all = []

    def initialize(name, id, url)
        @name, @id, @url = name, id, url
        save
    end

    def self.mass_create_from_api(businesses_array)
        businesses_array.each do |business_hash|
            self.new(business_hash["name"], business_hash["id"], business_hash["url"])
        end
    end

    def save 
        @@all << self
    end

    def self.all
        @@all
    end

end