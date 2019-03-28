require 'rspec'
require './app/products/product_manager'

describe ProductManager do

  it 'should have a list of products' do
    expect(subject.product_list).to be_a(Array)
  end

  context 'adding products' do
    let(:product_info) { {name:'test', price: 0.99, by_weight: true, unit: 'lb'} }

    it 'should respond to add_product method' do
      expect(subject).to respond_to(:add_product)
    end

    it 'should add a product' do
      expect{ subject.add_product(product_info) }
        .to change { subject.product_list.count }
              .from(0).to(1)

      p1 = subject.product_list.first
      expect(p1.name).to eq('test')
      expect(p1.id).to eq(0)
    end

    it 'should add a product with unit price' do
      expect{ subject.add_product(product_info.merge({by_weight: false})) }
        .to change { subject.product_list.count }
              .from(0).to(1)

      p1 = subject.product_list.last
      expect(p1.by_weight).to eq(false)
      expect(p1.id).to eq(0)
    end

    it 'should ignore an id passed in parameters' do
      subject.add_product(product_info.merge({id: 20}))
      p1 = subject.product_list.last
      expect(p1.id).to eq(0)
    end

    it 'should update product if update:true' do
      subject.add_product(product_info)
      subject.add_product(product_info.merge({price: 1.99, update: true}))
      updated = subject.find_product_by_id(0)
      expect(updated.price).to eql(1.99)
    end

    context 'should add multiple products' do
      before do
        subject.add_product(product_info.merge({name: 'test2'}))
      end

      it 'should add a second item' do
        expect{ subject.add_product(product_info.merge({name: 'test3', by_weight: false})) }
          .to change { subject.product_list.count }
                .from(1).to(2)
      end

      it 'should not add the same product twice' do
        subject.add_product(product_info)
        subject.add_product(product_info)
        expect(subject.product_list.count).to eql(2)
      end

      it 'should set incremental id value' do
        subject.add_product(product_info.merge({name: 'test4'}))
        expect(subject.product_list.last.id).to eq(1)
        subject.add_product(product_info.merge({name: 'test5'}))
        expect(subject.product_list.last.id).to eq(2)
      end

      it 'should have an id that is independent of list length' do
        subject.add_product(product_info.merge({name: 'test4'}))
        subject.add_product(product_info.merge({name: 'test5'}))
        subject.add_product(product_info.merge({name: 'test6'}))
        removed = subject.product_list.pop
        subject.add_product(product_info.merge({name: 'test7'}))
        expect(subject.product_list.last.id).not_to eq(removed.id)
      end

      it 'should not add invalid product' do
        expect { subject.add_product({name:'test', price: 0.99, by_weight: true}) }
          .not_to change{ subject.product_list.count }
      end
    end
  end

  context 'find product' do
    context 'validations' do

      it 'should respond to' do
        expect(subject).to respond_to(:find_product).with(1).argument
      end

      it 'should fail without valid options, id or name' do
        expect{ subject.find_product({}) }.to raise_error(ArgumentError)
      end

      it 'should accept only id' do
        expect{ subject.find_product({id: 0}) }.not_to raise_error
      end

      it 'should only accept integer ID' do
        expect{ subject.find_product({id: 'A'}) }.to raise_error ArgumentError
        expect{ subject.find_product({id: ''}) }.to raise_error ArgumentError
      end

      it 'should accecpt only a non-empty name string' do
        expect{ subject.find_product({name:'A'}) }.not_to raise_error
      end

      it 'should not allow empty names' do
        expect{ subject.find_product({name:''}) }.to raise_error ArgumentError
      end
    end

    context 'found product' do
      before(:each) do
        subject.add_product({name:'Ground beef', price: 0.99, by_weight: true, unit: 'lb'})
        subject.add_product({name:'test', price: 1.99 })
      end
      it 'should find product by id' do
        product = subject.find_product({id: 0})
        expect(product.id).to eql(0)
        expect(product).to be_an_instance_of(Product)
      end

      it 'should return nil if not found' do
        product = subject.find_product({id: 10})
        expect(product).to eql(nil)
      end

      it 'should find product by name' do
        beef = subject.find_product({name: 'ground beef'})
        expect(beef).to be_an_instance_of(Product)
      end
    end
  end
end


