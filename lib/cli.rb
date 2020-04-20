class CLI

    def initialize
        @page = 1
        @limit = 20
    end

    def start
        introduction
        business_loop
    end

    def get_business_data(loc, query)
        puts "\n\n MAKING A NETWORK REQUEST ... \n\n"
        APIManager.search_businesses(loc, query, @page, @limit)
        #mass_get_reviews(Business.all)
    end

    def business_loop
        task_answer = ''
        while task_answer != 'exit' && @query_answer != 'exit' && @loc_answer != 'exit'
            puts "What would you like to do today? Select a number from the menu below."
            sleep(1)
            menu
            task_answer = gets.chomp.downcase
          
            if task_answer.to_i == 1
                puts "What are you looking for? (i.e. piano lessons, dance studios ...)"
                @query_answer = gets.chomp.downcase
                    break if @query_answer.downcase == 'exit'
             
                puts "In what city are you looking (i.e. Houston, Las Vegas ...)?"
                @loc_answer = gets.chomp.downcase
                puts "\n\n"
                    break if @loc_answer.downcase == 'exit'
                more_options_message
                get_business_data(@loc_answer, @query_answer)
                display_businesses

                next_answer = ''
                while next_answer != 'exit'
                    next_answer = gets.chomp.downcase
                
                    if next_answer == 'main menu'
                        start
                    elsif next_answer == 'prev'
                        if @page <= 1
                            puts "\n\n You are already on the first page."
                            more_options_message
                        else
                            decrease_page
                            display_businesses
                        end
                    elsif next_answer == 'next'
                        increase_page
                        _, stop = get_page_range
                        if Business.all.length < stop
                            get_business_data(@loc_answer, @query_answer)
                        end
                        display_businesses
                            
                    elsif valid?(next_answer)
                        more_details(Business.all[next_answer.to_i - 1])
                    else 
                        puts "Please enter a valid response."
                    end
                end

                break

            elsif task_answer.to_i == 2
                puts "show favorites" 
                break
            elsif task_answer != 'exit' && task_answer.to_i.abs > 2 
                puts "Please select a valid number or type 'exit' to leave the program."
                puts "\n\n"
            end
        end
        puts "You have left the program. Goodbye!"
    end

    def increase_page
        @page += 1
    end

    def decrease_page
        @page -= 1
    end

    def introduction
        puts "\n\n"
        puts "Welcome ClassiFinder!"
        sleep(2)
        puts "\n\n"
    end

    def menu          
        puts <<-MENU
    
..........MENU..........
1. New Yelp search
2. Browse Favorites list

        MENU
    end

    def more_options_message
        puts <<-MORE

            For more information on a business type the number of the business
            Type 'main menu' clear your search results and go back to the main menu
            Type 'next' to browse more businesses #{"or 'prev' to see the previous page" if @page > 1}
            Type 'exit' to exit the program

        MORE

    end

    def display_businesses

        start, stop = get_page_range
        puts "\n\nPAGE #{@page}"
        Business.all[start...stop].each.with_index(start) do |business, index|
        puts "\n"
        puts "#{index+1} .......................... "
        puts "Business Name: #{business.name}"
        puts "Rating: #{business.rating}"
        puts "Address: " + business.location["display_address"].join(", ")
        end
    end

    def get_page_range
        [(@page - 1) * @limit, @page * @limit]
    end

    def valid?(i)
        i.to_i.between?(1, Business.all.length)
    end

    def mass_get_reviews(business_array)
        start, stop = get_page_range
        business_array[start...stop].each do |business|
            APIManager.search_reviews(business.id)
        end
    end

    def get_reviews(business)    
        puts "\n\n MAKING A NETWORK REQUEST ... \n\n"
        APIManager.search_reviews(business.id)     
    end

    def display_reviews(business)
        #puts business.name
        business.reviews.each_with_index do |review, index|
            puts "#{index+1} .......................... "
            #puts "Business: #{review.business.name}"
            puts "Review by: #{review.user["name"]}"
            puts "Rating: #{review.rating}"
            puts "Review: #{review.text}"  
            puts "\n"  
        end
    end

    def more_details(business)
        get_reviews(business)
        categories = []
        business.categories.each { |category_hash| categories << category_hash["title"] } 

        puts "\n\n\n"
        puts "********** #{business.name.upcase} **********"
        puts "\n"
        puts "Rating: #{business.rating} | #{business.review_count} reviews"
        puts "Categories: " + categories.join(' | ') if categories != nil
        puts "Price: #{business.price}" if business.price !=nil
        puts "Phone: #{business.display_phone}" if business.display_phone != nil
        puts "Address: " + business.location["display_address"].join(", ") if business.location["display_address"] != nil
        puts "URL: #{business.url}" if business.url != nil
        puts "\n"
        puts "********** REVIEWS ***********"
        puts "\n"
        display_reviews(business)

    end
end

 # def get_business_choice
    #     commands = ['exit', 'next', 'prev']
    #     input = gets.strip.downcase
    #     if commands.include?(input.downcase)
    #         return input.downcase 
    #     elsif !valid?(input)
    #         puts "Enter a valid response"
    #         return "invalid"
    #     else
    #         return input.to_i - 1
    #     end
    # end