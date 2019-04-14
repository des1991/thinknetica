module Controller
  protected

  def select_from_menu(msg, menu, controller, arg = nil)
    loop do
      show_menu(menu)

      print msg

      answer = gets.to_i

      selected = menu.find { |item| answer == item[:answer] }

      next unless selected
      break if selected[:exit]
      
      controller.send(selected[:method], arg)
    end
  end

  def get_answer(msg)
    print msg

    gets.chomp
  end

  def print_list(msg, list, attr)
    puts msg

    puts '-' if list.empty?

    list.each_with_index do |item, index|
      puts "#{index + 1} - " + item.send(attr)
    end
  end

  def select_from_list(msg, list, items)
    list

    get_by_num(msg, items)
  end

  def get_by_num(msg, items)
    index = 0

    loop do
      print msg
      index = gets.to_i

      break if (1..items.length).cover?(index) || index.zero?
    end

    items[index - 1]
  end

  def create_train_by_type(type)
    train_number = get_answer('Номер поезда: ')

    if type == 1
      @trains << PassengerTrain.new(train_number)
    elsif type == 2
      @trains << CargoTrain.new(train_number)
    end
  rescue StandardError => e
    puts e.message
    retry
  end

  def wagon_action(train, action)
    if action == :add
      if train.type == :passenger
        wagon = PassengerWagon.new(get_answer('Кол-во мест в вагоне: ').to_i)
      elsif train.type == :cargo
        wagon = CargoWagon.new(get_answer('Объем вагона: ').to_i)
      end

      train.add_wagon(wagon)
    elsif action == :remove
      train.remove_wagon
    end
  end

  def change_stations_in_route(route, action)
    if action == :add
      station = select_from_list('Выберите станцию: ', show_stations, @stations)

      route.add_station(station)
    elsif action == :remove
      station = select_from_list(
        'Выберите станцию: ',
        show_stations(route),
        route.stations
      )

      route.remove_station(station)
    end
  end
end
