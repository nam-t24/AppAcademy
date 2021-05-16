require_relative "room"

class Hotel
    def initialize(name, hash)
        @name=name
        @rooms=Hash.new
        hash.each do |key,value|
            @rooms[key]= Room.new(value)
        end
    end
    def name
        @name.split(" ").map {|word| word.capitalize}.join(" ")
    end
    def rooms
        @rooms
    end
    def room_exists?(name)
        return true if @rooms.has_key?(name)
        false
    end
    def check_in(person, room_name)
        if(room_exists?(room_name))
            if(@rooms[room_name].add_occupant(person))
                puts "check in successful"
            else
                puts "sorry, room is full"
            end
        else
            puts "sorry, room does not exist"
        end
    end
    def has_vacancy?
        return false if @rooms.all? do |name, room_instance|
            room_instance.full?
        end
        true
    end
    def list_rooms
        @rooms.each do |name, instance|
            puts name + instance.available_space.to_s
        end
    end
end
