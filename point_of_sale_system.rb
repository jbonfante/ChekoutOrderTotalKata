class PointOfSaleSystem
  attr_accessor :products

  def initialize
    @products = ProductManager.new
  end

  def total
    0.0
  end

  def list_products

  end
end
