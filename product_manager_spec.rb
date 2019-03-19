require 'rspec'
require './product_manager'

describe ProductManager do

  it 'should have a list of products' do

    expect(subject.products).to be_a(Array)
  end
end

describe Product do
  context "New empty product" do
    it 'should have a name' do
      expect(subject.name).to eq('')
      expect(subject.price).to eq(0.0)
      expect(subject.by_weight).to be(false)
    end
  end

end
