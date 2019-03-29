class Station
  attr_reader :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    @trains << train
  end

  def trains_by_type(type)
    trains.select { |train| train.type == type }.length
  end

  def departure(train)
    @trains.delete(train)
  end
end

class Route
  def initialize(from, to)
    @from = from
    @to = to
    @stations = [@from, @to]
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
      @stations.delete(station)
  end

  def stations
    @stations.each { |station| puts station }
  end
end

class Train
  attr_accessor :speed
  attr_reader :type

  def initialize(number, type, wagons)
    @number = number
    @type = type
    @speed = 0
    @wagons = wagons
  end

  def stop
    @speed = 0
  end

  def wagons
    @wagons
  end

  def add_wagon
    @wagons += 1
  end

  def remove_wagon
    @wagons -= 1
  end

  def route=(route)
    @route = route
    @position = 0
  end

  def go_forward
    @position += 1
  end

  def go_back
    @position -= 1
  end

  def current_station
    @route.stations[@position]
  end

  def prev_station
    @route.stations[@position-1]
  end

  def next_station
    @route.stations[@position+1]
  end
end
