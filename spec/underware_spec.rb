require 'underware'

describe Underware::DoNothing do

  it "accepts any number of arguments" do 
    (0..100).each do |i|
      args = (0...i).to_a
      Underware::DoNothing.call(*args)
    end
  end


  it 'returns nil' do 
    expect(Underware::DoNothing.call).to be_nil
  end

end

describe Underware do 
  describe '#fold_underware' do 
    include Underware

    it 'returns DoNothing when given an empty Array' do 
      expect(fold_underware([])).to equal Underware::DoNothing
    end

    it 'yields to the middleware from left to right' do 
      f = lambda do |x, &block|
        expect(x).to eq(2)
        block.call(x * 2)
        expect(x).to eq(2)
      end

      g = lambda do |x, &block|
        expect(x).to eq(4)
        block.call(x * 2)
        expect(x).to eq(4)
      end

      h = lambda do |x, &block|
        expect(x).to eq(8)
      end

      folded = fold_underware([f, g, h])
      folded.call(2)
    end



    it 'allows the last piece of middleware to be specified as a block' do 
      f = lambda do |x, &block|
        expect(x).to eq(2)
        block.call(x * 2)
        expect(x).to eq(2)
      end

      g = lambda do |x, &block|
        expect(x).to eq(4)
        block.call(x * 2)
        expect(x).to eq(4)
      end

      folded = fold_underware([f, g]) do |x, &block|
        expect(x).to eq(8)
      end

      folded.call(2)
    end



    it 'does not explode when there is no middleware to yield to' do 
      f = lambda do |x, &block|
        expect(x).to eq(2)
        block.call(x * 2) # No explode, plz.  kthxbye
        expect(x).to eq(2)
      end

      folded = fold_underware([f])
      folded.call(2)
    end


    it 'requires each piece of middleware to yield control to the next piece of middleware' do
      f = lambda do |x, &block|
        expect(x).to eq(2)
      end

      g = lambda do |x|
        raise "Womp womp.  I shouldn't have been invoked!"
      end

      folded = fold_underware([f, g])
      folded.call(2)
    end





  end
end

