require 'logger'

class ProductManager
  attr_accessor :products, :logger

  def initialize
    @products = []
    @logger = Logger.new(STDOUT)
    logger.level = Logger::ERROR
  end

  def add_product(options={})
    begin
      product = Product.new(options.merge({id: products.count}))
      products.push(product)

    rescue ArgumentError => msg
      logger.error('Adding Product') { "#{msg}" }
    end
  end

  def find_product

  end
end


