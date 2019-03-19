require 'rspec'
require './product_manager'

describe ProductManager do

  it 'should have a list of products' do
    expect(subject.products).to be_a(Array)
  end

  context 'adding products' do
    it 'should respond to add_product method' do
      expect(subject).to respond_to(:add_product)
    end

    it 'should add a product' do
      product_info = {name:'test', price: 0.99, by_weight: true, unit: 'lb'}
      expect{ subject.add_product(product_info) }.to change(subject.products.count).from(0).to(1)
    end
  end
end


