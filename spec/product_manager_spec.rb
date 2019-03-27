require 'rspec'
require './product_manager'

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

      p1 = subject.product_list.first
      expect(p1.by_weight).to eq(false)
      expect(p1.id).to eq(0)
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
    it 'should respond to' do
      expect(subject).to respond_to(:find_product).with(1).argument
    end

    it 'should fail without valid options, id or name' do
      expect{ subject.find_product({}) }.to raise_error(ArgumentError)
    end

    it 'should accept only id' do
      expect{ subject.find_product({id: 0}) }.not_to raise_error
    end

    it 'should accecpt only a name string' do
      expect{ subject.find_product({name:'A'}) }.not_to raise_error
    end

    it 'should not allow empty names' do
      expect{ subject.find_product({name:''}) }.to raise_error
    end

  end
end


