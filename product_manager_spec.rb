require 'rspec'
require './product_manager'

describe ProductManager do

  it 'should have a list of products' do
    expect(subject.products).to be_a(Array)
  end

  context 'adding products' do
    let(:product_info) { {name:'test', price: 0.99, by_weight: true, unit: 'lb'} }

    it 'should respond to add_product method' do
      expect(subject).to respond_to(:add_product)
    end

    it 'should add a product' do
      expect{ subject.add_product(product_info) }
        .to change { subject.products.count }
              .from(0).to(1)

      p1 = subject.products.first
      expect(p1.name).to eq('test')
      expect(p1.id).to eq(0)
    end

    it 'should add a product with unit price' do
      expect{ subject.add_product(product_info.merge({by_weight: false})) }
        .to change { subject.products.count }
              .from(0).to(1)

      p1 = subject.products.first
      expect(p1.by_weight).to eq(false)
      expect(p1.id).to eq(0)
    end

    context 'should add multiple products' do
      before do
        subject.add_product(product_info.merge({name: 'test2'}))
      end

      it 'should add a second item' do
        expect{ subject.add_product(product_info.merge({name: 'test3', by_weight: false})) }
          .to change { subject.products.count }
                .from(1).to(2)
      end

      it 'should set incremental id value' do
        subject.add_product(product_info.merge({name: 'test4'}))
        expect(subject.products.last.id).to eq(1)
        subject.add_product(product_info.merge({name: 'test5'}))
        expect(subject.products.last.id).to eq(2)
      end

      it 'should not add invalid product' do
        expect { subject.add_product({name:'test', price: 0.99, by_weight: true}) }
          .not_to change{ subject.products.count }
      end
    end
  end
end


