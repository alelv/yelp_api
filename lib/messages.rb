class Messages

    
    def self.menu
        puts "What would you like to do today? Select a number from the menu below."
            sleep(1)      
        puts <<-MENU
    
..........MENU..........
1. New Yelp search
2. Browse Favorites list

Type 'exit' to leave the program

        MENU
    end

    def self.intro
        puts "\n\n"
        puts "Welcome Yelp Class Finder!"
        sleep(2)
        puts "\n\n"
    end

    def self.more_options_favorites_message
        puts <<-MORE

            For more information on a business type the number of the business
            Type a business by number followed by 'remove' (example: 1 remove) to remove a business from your favorte's list
            Type 'main menu' to go back to your homepage
            Type 'exit' to exit the program

        MORE

    end
    

end