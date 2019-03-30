require 'rspec'
require './app/point_of_sale_system'

describe PointOfSaleSystem do
  it 'should be able to create' do
    expect(subject).to be_truthy
  end

  it 'should have an transaction id counter' do
    expect(subject.transaction_counter).to eql(1)
  end

  context 'Requirements' do
    context 'Products' do
      it 'has a list of products in inventory' do
        expect(subject).to respond_to(:list_products)
      end

      it 'should be an array' do
        expect(subject.list_products).to be_a(Array)
      end

      it 'should have a Product Manager instance' do
        expect(subject.products).to be_an_instance_of(ProductManager)
      end
    end
  end

  context 'Total Calculations' do
    it 'should respond to total method' do
      expect(subject).to respond_to(:total)
    end

    it 'should calculate order total' do
      expect(subject.total).to eq(0.0)
    end
  end

  context 'Markdowns' do
    it 'should have a MarkdownManager instance' do
      expect(subject.markdowns).to be_an_instance_of(MarkdownManager)
    end
  end

  context 'Specials' do
    it 'should have a SpecialsManager instance' do
      expect(subject.specials).to be_an_instance_of(SpecialsManager)
    end
  end

  context 'Transactions' do
    it 'should have a transactions array' do
      expect(subject.transactions).to be_a(Array)
    end
  end
  
  context 'Scanning a product' do
    # # Accept a scanned item. The total should reflect an increase by the eaches price after the scan.
    # You will need a way to configure the prices of scannable items prior to being scanned.
    # #   Accept a scanned item and a weight. The total should reflect an increase of the price of the item for the given weight.
    before(:each) do
      subject.products.add({ name: 'Ground beef', price: 0.99, by_weight: true, unit: 'lb'})
      subject.products.add({ name: 'test', price: 1.99 })
    end

    it 'should add product to transaction with string' do
      subject.scan_product('ground beef', 1)
      expect(subject.current_transaction.items.length).to eql(1)
      
    end

    it 'should add product to transaction with integer id' do
      subject.scan_product(0, 1).scan_product(1, 1)
      expect(subject.current_transaction.items.length).to eql(2)
    end

    context 'Maintains totals with: ' do
      it 'One item' do
        subject.scan_product(1, 1)
        expect(subject.total).to eql(1.99)
      end

      it '2 of the same item' do
        subject.scan_product(1, 2)
        expect(subject.total).to eql(3.98)
      end

      it 'Same item scanned twice' do
        subject
          .scan_product(1, 1)
          .scan_product(1, 1)

        expect(subject.total).to eql(3.98)
        expect(subject.current_transaction.items.length).to eql(2)
      end

      it 'should work for items with a weight' do
        subject.scan_product(0, 0.5)
        expect(subject.total).to eql(0.49)
      end

      it 'should work with multiple items of different qty and weights' do
        subject
          .scan_product(0, 10)
          .scan_product(1, 2)
          .scan_product(0, 0.2)
          .scan_product(1, 5)
          .scan_product(0, 4.3)

        expect(subject.total).to eql(28.28)
      end
    end


  end

end

# USE CASES:

# #   Support a markdown. A marked-down item will reflect the eaches cost less the markdown when scanned. A weighted item with a markdown will reflect that reduction in cost per unit.
# #   Support a special in the form of "Buy N items get M at %X off." For example, "Buy 1 get 1 free" or "Buy 2 get 1 half off."
# # Support a special in the form of "N for $X." For example, "3 for $5.00"
# # Support a limit on specials, for example, "buy 2 get 1 free, limit 6" would prevent getting a third free item.
# #   Support removing a scanned item, keeping the total correct after possibly invalidating a special.
# #     Support "Buy N, get M of equal or lesser value for %X off" on weighted items.
