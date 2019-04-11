class CargoWagon < Wagon
  attr_reader :loaded_volume

  def initialize(capacity)
    @type = :cargo
    @capacity = capacity
    @loaded_volume = 0
  end

  def load(volume)
    raise "Not enough capacity!" if volume >= free_capacity

    @loaded_volume += volume
  end

  def free_capacity
    @capacity - @loaded_volume
  end
end
