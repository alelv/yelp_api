class ResponseStrategy

    def self.get_and_respond_to(prompt: , accepted_commands:, if_fail: ->(){ puts "That is an unknown command try again"},should_downcase: true, should_intergierize: false)
        loop do 
            puts prompt
            user_input = gets.strip
            user_input = user_input.downcase if should_downcase
            if accepted_commands.is_a? Array
                if accepted_commands.include? user_input
                    yield user_input
                    break
                else
                    if_fail[]
                end
            else
                if accepted_commands[user_input]
                    yield user_input
                    break
                else
                    if_fail[]
                end
            end
        end
    end

end


prompt = "Please select a valid input from 1-10"

accepted_commands  = Proc.new do |input|
    commands = ['exit', 'more']
    if !commands.include? input
        return (input.to_i - 1).between?(0,9)
    else
        return true
    end
end

ResponseStrategy.get_and_respond_to(prompt: prompt, accepted_commands: accepted_commands) do |user_input|

    display_business(Business.all[user_input])

end


ResponseStrategy.get_and_respond_to(prompt: "type iexit or more", accepted_commands: ["exit", "more"]) do |user_input|
    case user_input

    when "exit"

    when "more"
    end
end


# 2.6.1 :001 > hi_ale = ->(phrase){ puts "Hey Ale! #{phrase}"}
#  => #<Proc:0x00007f972aa3e760@(irb):1 (lambda)> 
# 2.6.1 :002 > say_hi = _
#  => #<Proc:0x00007f972aa3e760@(irb):1 (lambda)> 
# 2.6.1 :003 > say_hi["you are upser cool"]
# Hey Ale! you are upser cool
#  => nil 
# 2.6.1 :004 > saystuff = Proc.new do |phrase| 
# 2.6.1 :005 >     puts phrase
# 2.6.1 :006?>   puts "aleeeee!!!"
# 2.6.1 :007?>   end
#  => #<Proc:0x00007f972a877170@(irb):4> 
# 2.6.1 :008 > saystuff["whats uppppp"]
# whats uppppp