class CLI

    def start
        introduction
        business_loop
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
               
                display_businesses

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


    def introduction
        puts "\n\n"
        puts "Welcome ClassiFinder!"
        sleep(2)
        puts "\n\n"
    end

    def menu
        puts "\n\n\n"
        puts "..........MENU.........."
        puts "1. New Yelp search"
        puts "2. Browse Favorites list"
        puts "\n\n"
    end

    def display_businesses
        APIManager.search_businesses(@loc_answer, @query_answer)
        one_line_address = ''

        Business.all.each_with_index do |business, index|
        puts "\n"
        puts "#{index+1} .......................... "
        puts "Business Name: #{business.name}"
        puts "Rating: #{business.rating}"
        puts "Address: " + business.location["display_address"].join(", ")
        end
    end
end