require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'validation'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation

  NUMBER_FORMAT = /^[\d\wА-я]{3}-?[\d\wА-я]{2}$/

  attr_reader :number, :speed, :wagons, :type

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    validate!({ Number: { value: number, length: 5, format: NUMBER_FORMAT } })
    @@trains[number] = self
    register_instance
  end

  def valid?
    validate!({ Number: { value: number, length: 5, format: NUMBER_FORMAT } })
    true
  rescue
    false
  end

  def stop
    @speed = 0
  end

  def increase_speed
    @speed += 1
  end

  def decrease_speed
    @speed -= 1 unless @speed == 0
  end  

  def route=(route)
    @route = route
    @position = 0
    @route.stations[@position].add_train(self) 
  end

  def move_forward    
    change_station(:forward) unless @position == (@route.stations.length - 1)
  end

  def move_back    
    change_station(:back) unless @position == 0
  end

  def current_station
    @route.stations[@position]
  end

  def next_station
    @route.stations[@position + 1] unless @position == @route.stations.length
  end

  def prev_station
    @route.stations[@position - 1] unless @position == 0
  end

  def add_wagon(wagon)
    @wagons << wagon if (@type == wagon.type) && !wagons.include?(wagon)
  end

  def remove_wagon
    @wagons.pop(1) unless wagons.empty?
  end

  private
  ## 
  # Метод служит для смены станции
  # Чтобы не дублировать код в методах перемещения "next/prev_station", создан данный метод
  # Закрыт для использования из вне, т.к. для этого есть методы "next/prev_station"
  ##
  def change_station(action)
    @route.stations[@position].departure(self)

    if action == :forward
      @position += 1
    elsif action == :back
      @position -= 1
    end  
    
    @route.stations[@position].add_train(self)
  end
end
