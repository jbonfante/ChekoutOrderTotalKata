class Product
  attr_accessor :name, :price, :by_weight, :unit
  attr_reader :id

  def initialize(options = {})
    @name = options[:name] || ''
    @price = options[:price] || 0.0

    set_product_unit(options)
    @by_weight = options[:by_weight] || false
    @id = options[:id] || 0
  end

  def cost
    by_weight ? "$#{display_price}/#{unit}" : "$#{display_price}/each"
  end

  def display_price
    "#{'%.2f' % price}"
  end

  def to_s
    "Product: \tID: #{id} #{name} \t Price: #{cost}"
  end

  def update(options={})
    if valid_weight_options?(options)
      options.each do |key, value|
        m = "#{key}="
        send( m, value ) if respond_to?( m )
      end
    end
  end

  private

  def valid_weight_options?(options)
    if options[:by_weight]
      return false unless options[:unit]
      return true
    end
    true
  end


  def set_product_unit(options)
    if valid_weight_options?(options)
      @unit = options[:unit]
    else
      @unit = nil
      missing_unit_error
    end
  end

  def missing_unit_error
    raise(ArgumentError.new("Missing Unit. A Unit is required, when item price is by weight"))
  end
end
