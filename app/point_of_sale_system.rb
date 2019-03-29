require './app/products/product_manager'
require './app/markdowns/markdown_manager'
require './app/specials/specials_manager'

class PointOfSaleSystem
  attr_accessor :products, :markdowns, :specials, :transactions

  def initialize
    @products = ProductManager.new
    @markdowns = MarkdownManager.new
    @specials = SpecialsManager.new
    @transactions = []
  end

  def total
    0.0
  end

  def list_products
    products.list
  end
end
