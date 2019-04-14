class PassengerWagon < Wagon
  attr_reader :taken_seats

  def initialize(seats)
    @type = :passenger
    @seats = seats
    @taken_seats = 0
  end

  def take_seat
    raise 'Not enough seats!' if @taken_seats >= @seats

    @taken_seats += 1
  end

  def free_seats
    @seats - @taken_seats
  end
end
