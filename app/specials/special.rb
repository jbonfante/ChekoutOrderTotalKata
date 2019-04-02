class Special
  attr_accessor :product_id, :price, :name, :n_items, :m_items, :limit, :free
  attr_reader :id, :created_at

  def initialize(options = {})
    @id = options[:id] || 0
    @name = options[:name] || 'UNTITLED'
    @free = options[:free] || false
    @limit = options[:limit] || 0
    @m_items = options[:m_items] || 0
    @n_items = options[:n_items] || 0
    @price = options[:price] || 0.0
    @product_id = options[:product_id]
    self.x_off = options[:x_off] if options[:x_off]
    @created_at = DateTime.now
  end

  def bogo?
    return false unless free || x_off == 1.0
    true
  end

  def x_off=(num)
    puts "Setting x_off #{num}"
    @x_off = num.to_f/100.0
  end

  def x_off
    @x_off
  end

  def to_s
    "#{name}"
  end
end
