require_relative 'instance_counter'
require_relative 'validation'

class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

  @@all = []

  def self.all
    @@all
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!(name, "Name")
    @@all << self
    register_instance
  end

  def valid?
    validate!(name, "Name")
    true
  rescue
    false
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
