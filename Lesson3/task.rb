class Station
  attr_reader :name, :trains

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
  attr_reader :stations

  def initialize(from, to)
    @stations = [from, to]
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station)
    return "Error! Can't remove start/end station!" if station == @stations[0] || station == @stations[-1]

    @stations.delete(station)
  end
end

class Train
  attr_reader :type, :speed

  def initialize(number, type, wagons)
    @number = number
    @type = type
    @speed = 0
    @wagons = wagons
  end

  def stop
    @speed = 0
  end

  def speed=(speed)
    return "Error! Speed must be positive number!" if speed < 0

    @speed = speed
  end

  def wagons
    @wagons
  end

  def wagon_action(action)
    stop

    if action == "add"
      @wagons += 1
    elsif action == "remove"
      return "Error! Train has no wagons!" if wagons == 0

      @wagons -= 1
    end      
  end

  def route=(route)
    @route = route
    @position = 0
    @route.stations[@position].add_train(self) 
  end

  def go_forward
    return "Error! Train should't be on the end station!" if @position == @route.stations.length

    change_station("forward")
    @position += 1
  end

  def go_back
    return "Error! Train should't be on the start station!" if @position == 0

    change_station("back")
    @position -= 1
  end

  def change_station(action)
    @route.stations[@position].departure(self)

    if action == "forward"
      @route.stations[@position + 1].add_train(self)
    elsif action == "back"            
      @route.stations[@position - 1].add_train(self)
    end
  end

  def current_station
    @route.stations[@position]
  end

  def prev_station
    @route.stations[@position - 1]
  end

  def next_station
    @route.stations[@position + 1]
  end
end
