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
    station = select_from_list('Выберите станцию: ', show_stations, @stations)

    station.each_train do |train|
      print "Номер: #{train.number}, "
      print "Тип: #{train.type}, "
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
    route = select_from_list('Выберите маршрут: ', show_routes, @routes)

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
      print "#{number} - "
      print "Номер: #{number}, "
      print "Тип: #{wagon.type}, "

      if wagon.type == :passenger
        puts "Свободно: #{wagon.free_seats}, Занято: #{wagon.taken_seats}"
      elsif wagon.type == :cargo
        puts "Свободно: #{wagon.free_capacity}, Занято: #{wagon.loaded_volume}"
      end

      number += 1
    end
  end

  def load_wagon(train)
    wagon = select_from_list('Выберите вагон: ', show_wagons(train), train.wagons)

    if wagon.type == :passenger
      wagon.take_seat

      puts 'Место занято.'
    elsif wagon.type == :cargo
      wagon.load(get_answer('Введите объем: ').to_i)

      puts 'Объем занят.'
    end
  end

  def create_route
    show_stations

    route_from_to = get_answer('Укажите маршрут (от-до): ').split('-')

    route_from = @stations[route_from_to.first.to_i - 1]
    route_to = @stations[route_from_to.last.to_i - 1]

    route = Route.new(route_from, route_to)

    puts "Маршрут '#{route_from.name} -> #{route_to.name}' создан."

    @routes << route
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
