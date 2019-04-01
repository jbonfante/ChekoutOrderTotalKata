class Markdown
  attr_accessor :product_id, :price, :name
  attr_reader :id

  def initialize(options = {})
    @price = options[:price] || 0.0
    @product_id = options[:product_id]
    @id = options[:id] || 0
    @name = options[:name] || 'UNTITLED'
  end

end
