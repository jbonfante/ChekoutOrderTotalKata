require 'logger'

class ProductManager
  attr_accessor :product_list, :logger, :id_counter

  def initialize
    @id_counter   = 0
    @product_list = []
    @logger       = Logger.new(STDOUT)
    logger.level  = Logger::ERROR
  end

  def add_product(options={})
    begin
      product = Product.new(options.merge({id: id_counter}))
      product_list.push(product)
      self.id_counter += 1

    rescue ArgumentError => msg
      logger.error('Error Adding Product: ') { "#{msg}" }
    end
  end

  def find_product(options={id:nil , name:nil})
    raise ArgumentError.new('ID or NAME are required') unless [:name, :id].map { |x| options.include?(x)}.any?

  end
end


