class Passenger
    attr_reader :name
    def initialize(name_)
        @name=name_
        @flight_numbers=[]
    end
    def has_flight?(flight)
        @flight_numbers.include? flight.upcase
    end
    def add_flight(flight)
        if !has_flight?(flight)
            @flight_numbers<<flight.upcase
        end
    end
end