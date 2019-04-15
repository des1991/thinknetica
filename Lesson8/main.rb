require_relative 'train.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'wagon.rb'
require_relative 'passenger_wagon.rb'
require_relative 'cargo_wagon.rb'
require_relative 'route.rb'
require_relative 'station.rb'
require_relative 'menu.rb'

class RailRoad
  include Menu

  attr_reader :trains

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def start
    select_from_menu('Выберите раздел из списка: ', MENU, self)
  end

  def create_station
    station_name = get_answer('Название станции: ')

    @stations << Station.new(station_name)
  rescue StandardError => e
    puts e.message

    retry
  end

  def show_stations(route = nil)
    list = route.nil? ? @stations : route.stations

    print_list('Станции:', list, :name)
  end

  def show_trains_on_station
    show_stations
    station = select_from_list('Выберите станцию: ', @stations)

    station.each_train do |train|
      print "Номер: #{train.number}, Тип: #{train.type}, "
      puts "Вагонов: #{train.wagons.length}"
    end
  end

  def create_train
    loop do
      puts '1 - Пассажирский'
      puts '2 - Грузовой'

      train_type = get_answer('Тип: ').to_i

      next unless [1, 2].include?(train_type)

      create_train_by_type(train_type)

      break if [1, 2].include?(train_type)
    end
  end

  def show_trains
    print_list('Поезда:', @trains, :number)
  end

  def route=(train)
    show_routes
    route = select_from_list('Выберите маршрут: ', @routes)

    train.route = route

    puts "Поезду '#{train.number}' задан маршрут."
  end

  def add_wagon(train)
    wagon_action(train, :add)
  end

  def remove_wagon(train)
    wagon_action(train, :remove)
  end

  def move_forward(train)
    train.move_forward
  end

  def move_back(train)
    train.move_back
  end

  def show_wagons(train)
    puts '-' if train.wagons.empty?

    number = 1

    train.each_wagon do |wagon|
      print "#{number} - Номер: #{number}, Тип: #{wagon.type}, "

      show_wagons_capacity(wagon)

      number += 1
    end
  end

  def load_wagon(train)
    show_wagons(train)
    wagon = select_from_list('Выберите вагон: ', train.wagons)

    load_wagon_by_type(wagon)
  end

  def create_route
    show_stations

    stations = get_from_to('Укажите маршрут (от-до): ', '-', @stations)

    @routes << Route.new(stations.first, stations.last)

    puts 'Маршрут создан.'
  rescue StandardError => e
    puts e.message

    retry
  end

  def show_routes
    @routes.each_with_index do |route, index|
      print "#{index + 1} - "

      stations_name = []

      route.stations.each { |station| stations_name << station.name }

      puts stations_name.join(' -> ')
    end
  end

  def show_stations_in_route(route)
    show_stations(route)
  end

  def add_station_to_route(route)
    change_stations_in_route(route, :add)
  end

  def remove_station_from_route(route)
    change_stations_in_route(route, :remove)
  end
end

rr = RailRoad.new
rr.start
