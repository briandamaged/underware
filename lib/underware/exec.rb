
require_relative 'fold'

module Underware

  def exec_underware(mws, *args, &block)
    fold_underware(mws, &block).call(*args)
  end
  module_function :exec_underware


  class << self
    alias_method :exec, :exec_underware
  end

end
