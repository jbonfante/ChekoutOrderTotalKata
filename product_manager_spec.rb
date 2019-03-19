require 'rspec'
require './product_manager'

describe ProductManager do

  it 'should have a list of products' do

    expect(subject.products).to be_a(Array)
  end
end


