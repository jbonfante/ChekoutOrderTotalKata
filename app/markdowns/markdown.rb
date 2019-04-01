class Markdown
  attr_accessor :product_id, :price, :name
  attr_reader :id, :created_at

  def initialize(options = {})
    @id = options[:id] || 0
    @name = options[:name] || 'UNTITLED'
    @price = options[:price] || 0.0
    @product_id = options[:product_id]
    @created_at = DateTime.now
  end

end
