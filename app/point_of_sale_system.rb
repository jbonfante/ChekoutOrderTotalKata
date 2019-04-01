require './app/products/product_manager'
require './app/markdowns/markdown_manager'
require './app/specials/specials_manager'

class Transaction
  attr_reader :transaction_id
  attr_accessor :items

  def initialize(id)
    @transaction_id = id
    @items = []
  end

  def append(product_id, amount)
    items.push({id: product_id, amount: amount})
    self
  end

  def delete(product_id)
    items.delete_at(items.index {|x| x[:id] == product_id})
  end

  def modify(product_id, amount)
    if (i = items.index {|x| x.id == product_id})
      items[i] = {id: product_id, amount: amount}
    end
  end
end

class PointOfSaleSystem
  attr_accessor :products, :markdowns, :specials, :transactions, :transaction_counter

  def initialize
    @products            = ProductManager.new
    @markdowns           = MarkdownManager.new
    @specials            = SpecialsManager.new
    @transaction_counter = 0
    @transactions        = []
    start_transaction
  end

  def total
    current_transaction.items.map do |item|
      prod = products[item[:id]]
      price = (markdowns[item[:id]] || prod).price
      amt  =  prod.by_weight ? item[:amount] : (item[:amount]).ceil
      (price * amt)
    end.inject(0.0, &:+).truncate(2)
  end

  def list_products
    products.list
  end

  def start_transaction
    new_transaction      = Transaction.new(transaction_counter)
    @transaction_counter += 1
    transactions.push(new_transaction)
    self
  end

  def current_transaction
    transactions.last
  end

  def scan_product(product_id, amount)
    if (found = products[product_id])
      current_transaction.append(found.id, amount)
    end
    self
  end

  def removed_scanned_item(product_id)
    if (found = products[product_id])
      current_transaction.delete(found.id)
    end
    self
  end


end
