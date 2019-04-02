require './app/products/product_manager'
require './app/markdowns/markdown_manager'
require './app/specials/specials_manager'

class Transaction
  attr_reader :transaction_id, :logger
  attr_accessor :items

  def initialize(id)
    @transaction_id = id
    @items = []
    @logger      = Logger.new(STDOUT)
    logger.level = Logger::INFO
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
  attr_accessor :products, :markdowns, :specials, :transactions, :transaction_counter, :logger

  def initialize
    @products            = ProductManager.new
    @markdowns           = MarkdownManager.new
    @specials            = SpecialsManager.new
    @transaction_counter = 0
    @transactions        = []
    @logger      = Logger.new(STDOUT)
    logger.level = Logger::INFO

    start_transaction
  end

  def sub_total
    current_transaction.items.map do |item|
      prod = products[item[:id]]
      price = (markdowns[item[:id]] || prod).price
      amt  =  prod.by_weight ? item[:amount] : (item[:amount]).ceil
      (price * amt)
    end
  end

  def total
    ((sub_total.inject(0.0, &:+)) + apply_specials_discount)
      .truncate(2)
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

  def applicable_specials
    current_transaction.items.map do |item|
      prod = products[item[:id]]
      specials.find({product_id: prod.id })
    end.uniq
  end

  def apply_specials_discount
    applicable_specials.map do |special|
      if special
        product = products.find({id: special.product_id})
        n_items = special.n_items
        m_items =special.m_items
        min_items = n_items + m_items

        purchased_items = current_transaction
                            .items
                            .filter {|x| x[:id] == special.product_id}
                            .inject(0.0) {|x,y| y[:amount] + x }

        puts("pur #{purchased_items}")
        puts("min items: #{min_items}")
        puts "limit: #{special.limit}"
        puts "@@@@@@@@@@@@@@@@@"
        if purchased_items >= min_items
          purchased_items = check_limits(purchased_items, special)

          discount = if special.x_off
                       special.x_off * (purchased_items/min_items).floor
                     else
                       (purchased_items/min_items).floor
                     end
          logger.info(discount)
          logger.info(special.x_off)
          0 - (product.price * discount)
        end
      else
        0.0
      end
    end.compact.reduce(0.0, &:+)
  end

  private

  def check_limits(purchased_items, special)
    if special.limit? && purchased_items > special.limit
      purchased_items = special.limit
    end
    purchased_items
  end


end
