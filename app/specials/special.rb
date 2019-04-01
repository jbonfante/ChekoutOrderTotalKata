class Special
  attr_accessor :product_id, :price, :name, :n_items, :m_items, :x_off, :limit, :free
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
    @x_off = options[:x_off]
    @created_at = DateTime.now
  end

  def bogo?
    return false unless free || x_off == 100
    true
  end
end
