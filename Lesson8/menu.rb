require_relative 'controller.rb'

module Menu
  include Controller

  MENU = [
    { title: 'Станции', answer: 1, method: :stations_menu },
    { title: 'Поезда', answer: 2, method: :trains_menu },
    { title: 'Маршруты', answer: 3, method: :routes_menu },
    { title: 'Выход', answer: 0, exit: true }
  ].freeze

  STATIONS_MENU = [
    { title: 'Создать', answer: 1, method: :create_station },
    { title: 'Список', answer: 2, method: :show_stations },
    { title: 'Поезда на станции', answer: 3, method: :show_trains_on_station },
    { title: 'Назад', answer: 0, exit: true }
  ].freeze

  TRAINS_MENU = [
    { title: 'Создать', answer: 1, method: :create_train },
    { title: 'Список', answer: 2, method: :show_trains },
    { title: 'Управление поездом', answer: 3, method: :edit_train },
    { title: 'Назад', answer: 0, exit: true }
  ].freeze

  TRAIN_MENU = [
    { title: 'Назначить маршрут', answer: 1, method: :route= },
    { title: 'Добавить вагон', answer: 2, method: :add_wagon },
    { title: 'Удалить вагон', answer: 3, method: :remove_wagon },
    { title: 'Ехать Вперед', answer: 4, method: :move_forward },
    { title: 'Ехать Назад', answer: 5, method: :move_back },
    { title: 'Список вагонов', answer: 6, method: :show_wagons },
    { title: 'Занять место/объем в вагоне', answer: 7, method: :load_wagon },
    { title: 'Назад', answer: 0, exit: true }
  ].freeze

  ROUTES_MENU = [
    { title: 'Создать', answer: 1, method: :create_route },
    { title: 'Список', answer: 2, method: :show_routes },
    { title: 'Управление маршрутом', answer: 3, method: :edit_route },
    { title: 'Назад', answer: 0, exit: true }
  ].freeze

  ROUTE_MENU = [
    { title: 'Список', answer: 1, method: :show_stations_in_route },
    {
      title: 'Добавить промежуточную станцию',
      answer: 2,
      method: :add_station_to_route
    },
    {
      title: 'Удалить промежуточную станцию',
      answer: 3,
      method: :remove_station_from_route
    },
    { title: 'Назад', answer: 0, exit: true }
  ].freeze

  def show_menu(menu)
    menu.each { |item| puts "#{item[:answer]} - #{item[:title]}" }
  end

  def stations_menu
    select_from_menu('Выберите действие: ', STATIONS_MENU, self)
  end

  def trains_menu
    select_from_menu('Выберите действие: ', TRAINS_MENU, self)
  end

  def edit_train
    train = select_from_list('Выберите поезд: ', show_trains, @trains)

    select_from_menu('Выберите действие: ', TRAIN_MENU, self, train)
  end

  def routes_menu
    select_from_menu('Выберите действие: ', ROUTES_MENU, self)
  end

  def edit_route
    route = select_from_list('Выберите маршрут: ', show_routes, @routes)

    select_from_menu('Выберите действие: ', ROUTE_MENU, self, route)
  end
end
