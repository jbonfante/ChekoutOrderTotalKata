require 'rspec'
require './app/specials/specials_manager'

describe SpecialsManager do

  context 'initialization' do
    it 'should have a list of markdown items' do
      expect(subject.list).to be_a(Array)
    end

    it 'should have an id_counter of zero' do
      expect(subject.id_counter).to eql(0)
    end
  end
end
