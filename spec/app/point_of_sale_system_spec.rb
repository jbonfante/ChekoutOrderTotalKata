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

    it 'should maintain total after deleting a scanned item' do
      subject.products.add({ name: 'Ground beef', price: 0.99, by_weight: true, unit: 'lb'})
      subject.scan_product(0, 1)

      expect(subject.total).to eq(0.99)
      expect(subject.removed_scanned_item(0).total).to eql(0.0)
    end

  end

  context 'Markdowns' do
    before(:each) do
      subject.products.add({ name: 'Ground beef', price: 0.99, by_weight: true, unit: 'lb'})
      subject.products.add({ name: 'test', price: 1.99 })
      subject.products.add({ name: 'Shampoo', price: 10.99 })
    end

    it 'should have a MarkdownManager instance' do
      expect(subject.markdowns).to be_an_instance_of(MarkdownManager)
    end

    it 'should add a markdown for product' do
      product = subject.products[0]
      markdown = { product_id: product.id, price: 0.49, name: product.name }
      expect{ subject.markdowns.add(markdown) }
        .to change { subject.markdowns.list.length }
              .from(0).to(1)
    end
    context 'with valid markdown' do
      before(:each) do
        products = subject.products
        subject.markdowns.add({ product_id: products[0].id, price: 0.49, name: products[0].name })
        subject.markdowns.add({ product_id: products[1].id, price: 0.99, name: products[1].name })
      end

      it 'should use the markdown as item cost' do
        subject.scan_product(1, 1)
        expect(subject.total).to eql(0.99)
      end

      it 'should use item cost for weighted items' do
        subject.scan_product(0, 0.5)
        expect(subject.total).to eql(0.24)
      end

      it 'should not apply a markdown for items without one' do
        subject.scan_product(2, 2)
        expect(subject.total).to eql(21.98)
      end
    end
  end

  context 'Specials' do
    before(:each) do
      subject.products.add({ name: 'Ground beef', price: 0.99, by_weight: true, unit: 'lb'})
      subject.products.add({ name: 'test', price: 2.00 })
    end

    it 'should have a SpecialsManager instance' do
      expect(subject.specials).to be_an_instance_of(SpecialsManager)
    end

    it 'should add a BOGO special' do
      subject.specials
        .add({name: 'Buy 1 Get 1 Free', product_id: 1, n_items: 1, m_items: 1, free: true})
      expect(subject.specials.list.length).to eql(1)
    end

    context 'BOGO Specials' do
      before(:each) do
        subject
          .specials
          .add({name: 'Buy 1 Get 1 Free', product_id: 1, n_items: 1, m_items: 1, free: true})
      end

      it 'should use Specials discount buy one get one' do
        subject.scan_product('test', 2)
        expect(subject.total).to eql(2.0)
      end

      it 'should give 2 free when purchasing 4' do
        subject
          .scan_product('test', 2)
          .scan_product('test', 2)
        expect(subject.total).to eql(4.0)
      end

      it 'should give 2 free when purchasing 5' do
        subject
          .scan_product('test', 2)
          .scan_product('test', 2)
          .scan_product('test', 1)
        expect(subject.total).to eql(6.00)

      end

      it 'should give 3 free when purchasing 6' do
        subject
          .scan_product('test', 6)
        expect(subject.total).to eql(6.00)

      end

      it 'should give 3 free when purchasing 7' do
        subject
          .scan_product('test', 7)
        expect(subject.total).to eql(8.00)
      end

      it 'should give 50 free when purchasing 100' do
        subject
          .scan_product('test', 100)
        expect(subject.total).to eql(100.0)
      end

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

      it 'should round decimals up for items sold with each pricing' do
        subject.scan_product(1, 0.5)
        expect(subject.total).to eql(1.99)
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
