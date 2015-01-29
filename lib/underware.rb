
module Underware

  # Base class for middleware.  Basically, it
  # just demonstrates the interface that you
  # need to support.
  class BaseMW
    def call(*args)
      raise NotImplementedError
    end
  end


  class Folded < BaseMW
    attr_reader :left, :right

    def initialize(left, right)
      @left  = left
      @right = right
    end

    def call(*args)
      left.call(*args) do |*result|
        right.call(*args)
      end
    end
  end

  def fold_underware(*args, &block)
    return fold_underware(*args, block) if block_given?

    args.reverse_each.inject do |folded, mw|
      Folded.new(mw, folded)
    end
  end
  module_function :fold_underware


  class << self
    alias_method :fold, :fold_underware
  end

end
