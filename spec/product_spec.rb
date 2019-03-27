require 'rspec'
require './product'

describe Product do
  context "New empty product" do
    it 'should have a name' do
      expect(subject.name).to eq('')
    end

    it 'should have a price' do
      expect(subject.price).to eq(0.0)
    end

    it 'should not be by weight and no unit value' do
      expect(subject.by_weight).to be(false)
      expect(subject.unit).to be_nil
    end

    it 'should have an id' do
      expect(subject.id).to be(0)
    end
  end

  context "Product with unit(each) price" do
    subject { Product.new({name: 'Product 1', price: 2.00, by_weight: false})}

    it 'should have a name' do
      expect(subject.name).to eq('Product 1')
    end

    it 'should have a name and price with each' do
      expect(subject.to_s).to eq("Product: \tID: 0 Product 1 \t Price: $2.00/each")
    end

    it 'should have a price' do
      expect(subject.price).to eq(2.00)
    end

    it 'should not be by weight and no unit value' do
      expect(subject.by_weight).to be(false)
      expect(subject.unit).to be_nil
    end

    it 'should ignore unit is by weight is false' do
      subject.unit = 'lb'
      expect(subject.to_s).to eq("Product: \tID: 0 Product 1 \t Price: $2.00/each")
    end

  end

  context "with weight price (per pound)" do
    subject { Product.new({name: 'Product 1', price: 2.00, by_weight: true, unit: 'lb'})}

    it 'should have a name' do
      expect(subject.name).to eq('Product 1')
    end

    it 'should have a name and price with unit' do
      expect(subject.to_s).to eq("Product: \tID: 0 Product 1 \t Price: $2.00/lb")
    end

    it 'should have a price' do
      expect(subject.price).to eq(2.00)
    end

    it 'should be by weight and have a unit value' do
      expect(subject.by_weight).to be(true)
      expect(subject.unit).to eq('lb')
    end

    context 'Invalid product' do

      it 'raises error' do
        expect{ Product.new({name: 'Invalid', price: 2.00, by_weight: true})}.to raise_error(ArgumentError)
      end
    end

    context 'Update product info' do
      subject { Product.new({name: 'Product 1', price: 2.00})}

      it 'should update name' do
        expect {subject.update({name: 'Changed'})}.to change {subject.name}.to('Changed')
        end

      it 'should update price' do
        expect {subject.update({price: 0.99})}.to change {subject.price}.to(0.99)
      end

      it 'should update unit and weight' do
        expect {subject.update({by_weight: true, unit: 'lb'})}
          .to change {subject.by_weight}.to(true)
                .and change {subject.unit}.to('lb')

      end

    end

  end

end
