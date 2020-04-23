
class CLI

    def initialize
        @page = 1
        @limit = 20
        @@favorites = []
    end

    def start
        introduction
        business_loop
    end

    def get_business_data(loc, query)
        puts "\n\n MAKING A NETWORK REQUEST ... \n\n"
        business_array = APIManager.search_businesses(loc, query, @page, @limit)
        if  business_array == nil || business_array.length < 1
            @status = 'N/A'
            if @page > 1   
                puts "There are no more pages!"
                decrease_page
            end
        else
            @status = 'good'
            Business.mass_create_from_api(business_array)
        end
    end

    def exit_in_queue?
        return @query_answer != "exit" && @loc_answer != 'exit'
    end
  
    def business_loop
        task_answer = ''
        while task_answer != 'exit' && exit_in_queue?
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
                
                get_business_data(@loc_answer, @query_answer)
                
                if @status == 'N/A'
                    puts "Sorry we couldn't find any results. Please try another search." 
                    start
                    break ##do I need this?
                elsif @status == 'good'
                    more_options_message
                    display_businesses 
                end

                next_answer = ''
                while next_answer != 'exit'
                    next_answer = gets.chomp.downcase
                
                    if next_answer == 'main menu'
                        Business.clear
                        Reviews.clear
                        start
                        break #just added this, do I need this?
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
                            display_businesses

                        else 
                            display_businesses
                        end
                        
                                             
                    elsif next_answer.include?('favorites')
                        fav_item = next_answer.gsub('favorites','').to_i
                        if valid?(fav_item)
                            @@favorites << Business.all[fav_item - 1]
                            puts "\n\n\n\n\n\n\n\n\n #{Business.all[fav_item - 1].name} has been added to your favorites."
                            puts "There are #{@@favorites.length} item(s) in your favorites list."
                            sleep(1)
                            more_options_message
                        else
                            puts "Please enter a valid number to add favorite or type 'exit' to leave the program."
                        end
                    elsif valid?(next_answer)
                        more_details(Business.all[next_answer.to_i - 1])
                    else 
                        puts "Please enter a valid response."
                    end
                end

                break

            elsif task_answer.to_i == 2
                puts "******************* #{@@favorites.length} item(s) in your FAVORITES LIST ************************"
                puts "\n\n\n"
                if @@favorites.length > 0 
                    more_options_favorites_message  
                    favorites
                    response = gets.chomp.downcase 
                    if response == 'exit'
                        break
                    elsif response == 'main menu'
                        start
                    elsif response.include?('remove')
                        remove_item = response.gsub('remove', '').to_i
                        if remove_item.between?(1,@@favorites.length)
                            puts "#{@@favorites[remove_item - 1].name} has been removed from your favorites."
                            @@favorites.delete_at(remove_item - 1)
                            start
                        else
                            puts "Please enter a valid number to remove a favorite or 'exit' to leave the program."
                        end
                    elsif response.to_i.between?(1,@@favorites.length)
                        more_details(@@favorites[response.to_i - 1])
                    else
                        puts "Please enter a valid response."
                    end 
                end
            elsif task_answer != 'exit' && task_answer.to_i.abs > 2 
                puts "Please select a valid number or type 'exit' to leave the program."
                puts "\n\n"
            end
        end
        puts "You have left the program. Goodbye!"
    end

    def display_businesses
        start, stop = get_page_range
        puts "\n\nPAGE #{@page}"
        Business.all[start...stop].each.with_index(start) do |business, index|
        puts "\n"
        puts "#{index+1} .......................... "
        display_single_business(business)
        end
    end

    def display_single_business(business)
        puts "Business Name: #{business.name}"
        puts "Rating: #{business.rating}"
        puts "Address: " + business.location["display_address"].join(", ")
    end

    def get_page_range
        [(@page - 1) * @limit  , @page * @limit ]
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
        #puts "\n\n MAKING A NETWORK REQUEST ... \n\n"
        APIManager.search_reviews(business.id)     
    end

    def display_reviews(business)
        business.reviews.each_with_index do |review, index|
            puts "#{index+1} .......................... "
            puts "Review by: #{review.user["name"]}"
            puts "Rating: #{review.rating}"
            puts "Review: #{review.text}"  
            puts "\n"  
        end
    end

    def more_details(business)
        get_reviews(business) if Reviews.get_reviews_from_business(business) == nil
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

    def favorites
        @@favorites.each.with_index do |business, index|
            puts "\n"
            puts "Item # #{index+1}"
            display_single_business(business)
        end
    end

    def add_to_favorites
        @@favorites << self
    end

    def increase_page
        @page += 1
    end

    def decrease_page
        @page -= 1
    end

    def more_options_favorites_message
        Messages.more_options_favorites_message
    end

    def introduction
        Messages.intro
    end

    def menu    
        Messages.menu
    end

    def more_options_message
        #puts Messages.more_options
        puts <<-MORE

            For more information on a business type the number of the business
            Type a business by number followed by 'favorites' (example: 4 favorites) to add a business to your favorte's list
            Type 'next' to browse more businesses #{"or 'prev' to see the previous page" if @page > 1}
            Type 'main menu' to go back to your homepage
            Type 'exit' to exit the program

        MORE
    end


end

