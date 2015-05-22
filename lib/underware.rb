
require 'underware/base_mw'
require 'underware/do_nothing'
require 'underware/fold'
require 'underware/exec'

def Underware(mws, *args, &block)
  Underware.exec(mws, *args, &block)
end


