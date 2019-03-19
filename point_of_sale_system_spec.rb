require 'rspec'
require './point_of_sale_system'
require './product_manager'

describe PointOfSaleSystem do
  it 'should be able to create' do
    expect(subject).to be_truthy
  end

  context 'Requirements' do
    context 'Products' do
      it 'has a product list' do
        expect(subject).to respond_to(:list_products)
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

end
