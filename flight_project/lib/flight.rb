class Flight
    attr_reader :passengers
    def initialize(flight_num, capacity_)
        @flight_number=flight_num
        @capacity=capacity_
        @passengers=[]
    end

    def full?
        @passengers.length<@capacity ? false : true
    end

    def board_passenger(passenger)
        if !full?()
            if(passenger.has_flight?(@flight_number))
                @passengers << passenger
            end
        end
    end
    def list_passengers
        arr=[]
        @passengers.each {|passenger| arr<<passenger.name}
        arr
    end
    def [](idx)
        @passengers[idx]
    end
    def <<(passenger)
        self.board_passenger(passenger)
    end
end