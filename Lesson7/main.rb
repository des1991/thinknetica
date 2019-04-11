require_relative 'train.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'wagon.rb'
require_relative 'passenger_wagon.rb'
require_relative 'cargo_wagon.rb'
require_relative 'route.rb'
require_relative 'station.rb'

class RailRoad
  attr_reader :trains
  def initialize
    @menus = ["Создавать станции", 
              "Создавать поезда", 
              "Создавать маршруты и управлять станциями в нем (добавлять, удалять)", 
              "Назначать маршрут поезду",
              "Добавлять вагоны к поезду",
              "Отцеплять вагоны от поезда",
              "Перемещать поезд по маршруту вперед и назад",
              "Просматривать список станций и список поездов на станции",
              "Выводить список вагонов у поезда",
              "Занимать место или объем в вагоне",
              "Выйти"
              ]
    @stations = []
    @trains = []
    @routes = []
  end

  def puts_separator
    puts "-----------------------------------------------"
  end

  def puts_menus
    @menus.each_with_index { |menu, index| puts "#{index + 1} - #{menu}" }
  end

  def puts_stations
    puts "Список станций:"
    @stations.each_with_index { |station, index| puts "#{index + 1} - #{station.name}" }
  end

  def puts_trains
    puts "Список поездов:"
    @trains.each_with_index { |train, index| puts "#{index + 1} - #{train.number}" }
  end

  def puts_routes
    puts "Список маршрутов:"
    @routes.each_with_index do |route, index|
      print "#{index + 1} - "
      route.stations.each_with_index { |station, station_index| print " -> " if station_index > 0; print station.name }
      print "\n"
    end
  end

  def start
    loop do
      puts_separator

      puts "Программа управления железной дороги:"
      puts_menus
      print "Введите число из меню: "
      selected_menu = gets.to_i

      break if selected_menu == (@menus.length)

      stations = []
      trains = []

      puts_separator

      case selected_menu
      when 1 # Создавать станции
        create_station
      when 2 # Создавать поезда
        create_train
      when 3 # Создавать маршруты и управлять станциями в нем (добавлять, удалять)
        create_route
      when 4 # Назначать маршрут поезду
        set_route_to_train
      when 5 # Добавлять вагоны к поезду
        add_wagon_to_train
      when 6 # Отцеплять вагоны от поезда
        remove_wagon_from_train
      when 7 # Перемещать поезд по маршруту вперед и назад
        move_train
      when 8 # Просматривать список станций и список поездов на станции
        browse_trains_in_station    
      when 9
        browse_wagons_of_train
      when 10
        load_wagon
      end      
    end
  end

  protected

  def create_station
    puts "Создать станцию:"       
    print "Название: "
    station_name = gets.chomp

    @stations << Station.new(station_name)

    puts "Станция '#{station_name}' создана."
  end

  def create_train
    loop do
      puts "Создать поезд:"
      puts "1 - Пассажирский"
      puts "2 - Грузовой"
      print "Тип: "
      train_type = gets.to_i

      unless [1, 2].include?(train_type)
        puts_separator
        puts "Введите тип из списка!"
        puts_separator
        next        
      end

      begin
        print "Номер поезда: "
        train_number = gets.chomp

        if train_type == 1
          @trains << PassengerTrain.new(train_number)

          puts "Создан пассажирский поезд с номером '#{train_number}'."
        elsif train_type == 2
          @trains << CargoTrain.new(train_number)

          puts "Создан грузовой поезд с номером '#{train_number}'."
        end
      rescue StandardError => e
        puts_separator
        puts e.message
        puts_separator
        retry
      end  

      break if [1, 2].include?(train_type) 
    end
  end

  def create_route
    puts "Создать маршрут:"
    puts_stations
    print "Укажите маршрут от - до (в формате '1 - 2'): "
    route_from_to = gets.chomp.split(" - ")
    route_from = @stations[route_from_to[0].to_i - 1]
    route_to = @stations[route_from_to[-1].to_i - 1]
    route = Route.new(route_from, route_to)

    puts "Маршрут '#{route_from.name} - #{route_to.name}'."        

    loop do
      puts "1 - Добавить промежуточную станцию"
      puts "2 - Удалить промежуточную станцию"    
      puts "3 - Выйти"
      print "Выберите действие: "
      route_selected_menu = gets.to_i

      if route_selected_menu == 1
        change_stations_in_route(route, :add)
      elsif route_selected_menu == 2
        change_stations_in_route(route, :remove)
      elsif route_selected_menu == 3
        break
      end
    end

    @routes << route
  end

  def change_stations_in_route(route, action)
    if action == :add
      puts "Добавить промежуточную станцию:"
    elsif action == :remove
      puts "Удалить промежуточную станцию:"
    end    

    station = choose_station

    if action == :add
      route.add_station(station)
    elsif action == :remove
      route.remove_station(station)
    end     
  end

  def set_route_to_train
    puts "Назначить маршрут:"
    train = choose_train
    puts "Выбран поезд '#{train.number}'"

    route = choose_route

    train.route = route
    puts "Поезду '#{train.number}' задан маршрут." 
  end

  def add_wagon_to_train
    wagon_action(:add)
  end

  def remove_wagon_from_train
    wagon_action(:remove)
  end

  def wagon_action(action)
    if action == :add
      puts "Добавить вагон к поезду:"
    elsif action == :remove
      puts "Отцепить вагон от поезда:"
    end

    train = choose_train 

    if action == :add  
      if train.type == :passenger
        print "Кол-во мест в вагоне: "
        wagon = PassengerWagon.new(gets.to_i)
      elsif train.type == :cargo
        print "Объем вагона: "
        wagon = CargoWagon.new(gets.to_i)
      end

      train.add_wagon(wagon)
    elsif action == :remove
      train.remove_wagon
    end 
  end

  def move_train
    puts "Переместить поезд по маршруту:"
    train = choose_train

    puts "1 - Вперед"
    puts "2 - Назад"
    print "Выберите действие: "
    train_action = gets.to_i

    if train_action == 1
      train.move_forward
    elsif train_action == 2
      train.move_back
    end
  end

  def browse_trains_in_station
    puts "Список станций и список поездов на станции:"
    station = choose_station

    puts "Список поездов на станции '#{station.name}':"
    station.each_train { |train| puts "Номер: #{train.number}, Тип: #{train.type}, Вагонов: #{train.wagons.length}" }
  end

  def browse_wagons_of_train
    puts "Список вагонов поезда:"
    train = choose_train

    puts "Список вагонов поезда '#{train.number}':"
    number = 1
    train.each_wagon do |wagon|
      print "Номер: #{number},"
      print "Тип: #{wagon.type},"
      if wagon.type == :passenger
        puts "Свободно: #{wagon.free_seats}, Занято: #{wagon.taken_seats}"
      elsif wagon.type == :cargo
        puts "Свободно: #{wagon.free_capacity}, Занято: #{wagon.loaded_volume}"
      end

      number += 1
    end
  end

  def load_wagon
    puts "Занять место или объем в вагоне:"
    train = choose_train
    number = 1
    train.each_wagon do |wagon|
      puts "#{number} - Вагон #{number}"
    end
    print "Выберите вагон из списка: "
    wagon = train.wagons[gets.to_i - 1]

    if wagon.type == :passenger
      wagon.take_seat
      puts "Место занято."
    elsif wagon.type == :cargo
      print "Введите объем: "
      wagon.load(gets.to_i)
      puts "Объем занят."
    end        
  end

  def choose_station
    puts_stations
    print "Выберите станцию из списка: "
    @stations[gets.to_i - 1]
  end

  def choose_train
    puts_trains
    print "Выберите поезд из списка: "
    @trains[gets.to_i - 1]
  end

  def choose_route
    puts_routes
    print "Выберите маршрут из списка: "
    @routes[gets.to_i - 1]
  end

end

rr = RailRoad.new
rr.start
