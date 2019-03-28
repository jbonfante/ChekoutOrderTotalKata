class MarkdownManager
  attr_accessor :markdown_list, :logger, :id_counter

  def initialize
    @id_counter   = 0
    @logger       = Logger.new(STDOUT)
    logger.level  = Logger::ERROR
    @markdown_list ||= []
  end
end
