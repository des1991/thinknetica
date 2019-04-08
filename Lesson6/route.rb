require_relative 'instance_counter'

class Route
  include InstanceCounter

  attr_reader :stations

  def initialize(from, to)
    validate!(from, to)
    @stations = [from, to]
    register_instance
  end

  def valid?
    validate!(@stations[0], @stations[-1])
    true
  rescue
    false
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station)
    @stations.delete(station) unless stations.values_at(0, -1).include?(station)
  end

  protected

  def validate!(from, to)
    raise "Error! Invalid arguments type." unless from.is_a?(Station) && to.is_a?(Station)
    raise "Error! Identical arguments." if from == to
  end
end
