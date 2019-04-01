require './app/base/base_manager'
require './app/specials/special'

class SpecialsManager < BaseManager
  def initialize
    super
    @managed_klass = Special
  end

  def find_by_product_id(proudct_id)
    list.find { |item| item.product_id == proudct_id }
  end

  def find(options = {product_id: nil})
    if options[:product_id]
      return find_by_product_id(options[:product_id])
    end
    super(options)
  end

end
