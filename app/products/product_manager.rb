require 'logger'
require 'active_support/all'
require './app/base/base_manager'
require './app/products/product'

class ProductManager < BaseManager

  def initialize
    super
    @managed_klass = Product
  end

  def find(options={ id: nil , name: nil})
    raise ArgumentError.new('ID or NAME are required') unless [:name, :id].map { |x| options.include?(x)}.any?
    super(options)
  end

end


