module Controller
  protected

  def show_menu(menu)
    menu.each { |item| puts "#{item[:answer]} - #{item[:title]}" }
  end

  def select_from_menu(msg, menu, controller, arg = nil)
    loop do
      selected = get_answer_from_menu(msg, menu)

      next unless selected
      break if selected[:exit]

      if arg.nil?
        controller.send(selected[:method])
      else
        controller.send(selected[:method], arg)
      end
    end
  end

  def get_answer(msg)
    print msg

    gets.chomp
  end

  def get_answer_from_menu(msg, menu)
    show_menu(menu)

    answer = get_answer(msg).to_i

    menu.find { |item| answer == item[:answer] }
  end

  def get_from_to(msg, separator, list)
    from_to = get_answer(msg).split(separator)

    from_to.map!(&:to_i)

    puts from_to.inspect

    [list[from_to.first - 1], list[from_to.last - 1]]
  end

  def print_list(msg, list, attr)
    puts msg

    puts '-' if list.empty?

    list.each_with_index do |item, index|
      puts "#{index + 1} - " + item.send(attr)
    end
  end

  def select_from_list(msg, items)
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

  def show_wagons_capacity(wagon)
    if wagon.type == :passenger
      puts "Свободно: #{wagon.free_seats}, Занято: #{wagon.taken_seats}"
    elsif wagon.type == :cargo
      puts "Свободно: #{wagon.free_capacity}, Занято: #{wagon.loaded_volume}"
    end
  end

  def load_wagon_by_type(wagon)
    if wagon.type == :passenger
      wagon.take_seat

      puts 'Место занято.'
    elsif wagon.type == :cargo
      wagon.load(get_answer('Введите объем: ').to_i)

      puts 'Объем занят.'
    end
  end

  def change_stations_in_route(route, action)
    if action == :add
      show_stations
      station = select_from_list('Выберите станцию: ', @stations)

      route.add_station(station)
    elsif action == :remove
      show_stations(route)
      station = select_from_list('Выберите станцию: ', route.stations)

      route.remove_station(station)
    end
  end
end
