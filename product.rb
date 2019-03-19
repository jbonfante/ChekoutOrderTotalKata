class Product
  attr_accessor :name, :price, :by_weight, :unit

  def initialize(options = {})
    self.name = options[:name] || ''
    self.price = options[:price] || 0.0
    if options[:by_weight]
      raise( ArgumentError.new("Missing Unit. A Unit is required, when item price is by weight")) unless options[:unit]
      self.unit = options[:unit]
    end
    self.by_weight = options[:by_weight] || false
  end

  def cost
    self.by_weight ? "$#{display_price}/#{unit}" : "$#{display_price}/each"
  end

  def display_price
    "#{'%.2f' % price}"
  end

  def to_s
    "Product: #{name} \t Price: #{cost}"
  end
end
