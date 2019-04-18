require_relative 'instance_counter'
require_relative 'accessors'
require_relative 'validation'

class Station
  include InstanceCounter
  include Accessors
  include Validation

  attr_reader :name, :trains
  attr_accessor_with_history :name

  validate :name, :presence

  @@all = []

  def self.all
    @@all
  end

  def initialize(name)
    self.name = name
    @trains = []
    validate!
    @@all << self
    register_instance
  end

  def change_name(name)
    self.name = name
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

  def each_train
    @trains.each { |train| yield train }
  end
end
