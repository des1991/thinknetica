require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'validation'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation

  NUMBER_FORMAT = /^[\d\wА-я]{3}-?[\d\wА-я]{2}$/.freeze

  attr_reader :number, :speed, :wagons, :type

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    validate!(Number: { value: number, length: 5, format: NUMBER_FORMAT })
    @@trains[number] = self
    register_instance
  end

  def valid?
    validate!(Number: { value: number, length: 5, format: NUMBER_FORMAT })
    true
  rescue StandardError
    false
  end

  def stop
    @speed = 0
  end

  def increase_speed
    @speed += 1
  end

  def decrease_speed
    @speed -= 1 unless @speed.zero?
  end

  def route=(route)
    @route = route
    @position = 0
    @route.stations[@position].add_train(self)
  end

  def move_forward
    change_station(:forward)
  end

  def move_back
    change_station(:back)
  end

  def current_station
    @route.stations[@position]
  end

  def next_station
    raise 'Error! No route.' unless @route
    raise 'End station!' if action == :forward &&
                            @position == (@route.stations.length - 1)

    @route.stations[@position + 1] unless @position == @route.stations.length
  end

  def prev_station
    raise 'Error! No route.' unless @route
    raise 'Start station!' if action == :back && @position.zero?

    @route.stations[@position - 1] unless @position.zero?
  end

  def add_wagon(wagon)
    @wagons << wagon if (@type == wagon.type) && !wagons.include?(wagon)
  end

  def remove_wagon
    @wagons.pop(1) unless wagons.empty?
  end

  def each_wagon
    @wagons.each { |wagon| yield wagon }
  end

  private

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
