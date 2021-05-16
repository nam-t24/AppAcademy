require "byebug"
class Employee
    attr_reader :name, :title
    def initialize(name, title)
        @name=name
        @title=title
        @earnings=0
    end
    def name
        @name
    end
    def title
        @title
    end
    def pay(amount)
        @earnings+=amount
    end

end
