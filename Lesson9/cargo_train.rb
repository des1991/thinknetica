class CargoTrain < Train
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  
  def initialize(number)
    super

    @type = :cargo
  end
end
