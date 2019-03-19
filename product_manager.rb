class ProductManager
  attr_accessor :products

  def initialize
    self.products = []
  end
end

class Product
  attr_accessor :name, :price, :by_weight, :unit

  def initialize(options = {})
    self.name = options[:name] || ''
    self.price = options[:price] || 0.0
    if options[:by_weight]
      raise( ArgumentError("Missing Unit. A Unit is required, when item price is by weight")) unless options[:unit]

    end
    self.by_weight = options[:by_weight] || false
  end
end
