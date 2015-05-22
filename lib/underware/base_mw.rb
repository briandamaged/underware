
module Underware

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

end

