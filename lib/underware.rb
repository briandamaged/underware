
module Underware
  # Just a generic do-nothing lambda
  DoNothing = ->(*args){ }

  # Base class for middleware.  Basically, it
  # just demonstrates the interface that you
  # need to support.
  class BaseMW
    def call(*args)
      raise NotImplementedError
    end

    def to_proc
      __other = self
      ->(*args){ __other.call(*args) }
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
        right.call(*result)
      end
    end
  end

  def fold_underware(mws, &block)
    return fold_underware([*mws, block]) if block_given?

    mws.reverse_each.inject(DoNothing) do |folded, mw|
      Folded.new(mw, folded)
    end
  end
  module_function :fold_underware


  def exec_underware(mws, *args, &block)
    fold_underware(mws, &block).call(*args)
  end
  module_function :exec_underware


  class << self
    alias_method :fold, :fold_underware
    alias_method :exec, :exec_underware
  end

end


def Underware(mws, *args, &block)
  Underware.exec(mws, *args, &block)
end


