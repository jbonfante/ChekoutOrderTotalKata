class PointOfSaleSystem
  attr_accessor :products, :markdowns

  def initialize
    @products = ProductManager.new
    @markdowns = MarkdownManager.new
  end

  def total
    0.0
  end

  def list_products
    products.product_list
  end
end
