require_relative "code"

class Mastermind
    def initialize(length)
        @secret_code = Code.random(length)
    end
    def print_matches(code)
        puts "Exact matches: " + @secret_code.num_exact_matches(code).to_s
        puts "Near matches: " + @secret_code.num_near_matches(code).to_s
    end

    def ask_user_for_guess
        puts "Enter a code"
        input=gets.chomp
        instance=Code.from_string(input)
        print_matches(instance)
        @secret_code==instance
    end

end
