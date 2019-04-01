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

    # Support a special in the form of "N for $X." For example, "3 for $5.00"
    # Support a limit on specials, for example, "buy 2 get 1 free, limit 6" would prevent getting a third free item.
    #   Support removing a scanned item, keeping the total correct after possibly invalidating a special.
    #     Support "Buy N, get M of equal or lesser value for %X off" on weighted items.
    context 'adding a special' do
      context 'Buy N get M for x% off' do
        # Support a special in the form of "Buy N items get M at %X off." For example, "Buy 1 get 1 free" or "Buy 2 get 1 half off."
        it 'should add Buy 1 get 1 for 100% off (free)' do
          subject.add({name: 'Buy 1 Get 1 Free', product_id: 0, n_items: 1, m_items: 1, free: true})
          subject.add({name: 'Buy 1 Get 1 100% off', product_id: 0, n_items: 1, m_items: 1, x_off: 100})
          sp = subject.find({name: 'Buy 1 Get 1 Free'})
          sp2 = subject.find({name: 'Buy 1 Get 1 100% off'})

          expect(sp.bogo?).to be_truthy
          expect(sp2.bogo?).to be_truthy
          expect(subject.list.length).to eql(2)
          expect(sp.limit).to eql(0)
          expect(sp.n_items).to eql(1)
          expect(sp.m_items).to eql(1)
          expect(sp.x_off).to be_nil
        end

        it 'should add Buy 2 get 1 half off' do
          subject.add({name: 'Buy 2 Get 1 half off', product_id: 0, n_items: 2, m_items: 1, x_off: 50})
          sp = subject.find({name: 'Buy 2 Get 1 half off'})

          expect(sp.bogo?).to be_falsey
          expect(sp.n_items).to eql(2)
          expect(sp.m_items).to eql(1)
          expect(sp.x_off).to eql(50)
        end

      end
    end
  end
end
