require 'rspec'


describe 'Point of Sale System' do

  before(:suite) do
    subject{ PointOfSaleSystem.new }
  end

  it 'should calculate order total' do
    expect(subject).to respond_to(:total)
  end
end
