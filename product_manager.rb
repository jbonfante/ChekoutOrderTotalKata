require 'logger'
require 'active_support/all'

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
      logger.error('Product Manager - Adding Product: ') { "#{msg}" }
    end
  end

  def find_product(options={id:nil , name:nil})
    raise ArgumentError.new('ID or NAME are required') unless [:name, :id].map { |x| options.include?(x)}.any?
    if options[:id]
      return find_product_by_id(options[:id])
    end
    if options[:name]
      return find_product_by_name(options[:name])
    end
  end

  def find_product_by_id(prod_id)
    raise ArgumentError.new('ID must be a valid integer') unless prod_id.is_a?(Integer)
    product_list.filter { |prod| prod.id == prod_id }.first || nil
  end

  def find_product_by_name(prod_name)
    raise ArgumentError.new('Name is blank') unless prod_name.present?
    product_list.filter { |prod| prod.name.downcase == prod_name.downcase }.first || nil
  end
end


