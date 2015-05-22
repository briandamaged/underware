
require_relative 'do_nothing'
require_relative 'base_mw'

module Underware

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


  class << self
    alias_method :fold, :fold_underware
  end

end

