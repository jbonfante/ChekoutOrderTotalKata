class SpecialsManager
  attr_accessor :specials_list, :logger, :id_counter

  def initialize
    @id_counter   = 0
    @logger       = Logger.new(STDOUT)
    logger.level  = Logger::ERROR
    @specials_list ||= []
  end

end
