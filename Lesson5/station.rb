require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :name, :trains

  @@all = []

  def self.all
    @@all
  end

  def initialize(name)
    @name = name
    @trains = []
    @@all << self
    register_instance
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
