# Underware #

Middleware for Ruby

## Installation ##

```bash
gem install underware
```

## Usage ##

If your object defines a ```#call``` method, then it can be used as middleware.  For example:

```ruby
class Add
  attr_reader :delta

  def initialize(delta)
    @delta = delta
  end

  def call(x)
    puts "BEFORE: #{x} + #{delta}"

    # Pass control to the next piece of middleware
    yield x + delta

    puts "AFTER:  #{x} + #{delta}"
  end
end
```

Now that we've defined some middleware, let's chain it together:

```ruby
require 'underware'

f = Underware.fold(Add.new(1), Add.new(-2), Add.new(3)) do |x|
  puts "THE VALUE IS: #{x}"
end

f.call(3)
```

This produces the following output:

```text
BEFORE: 3 + 1
BEFORE: 4 + -2
BEFORE: 2 + 3
THE VALUE IS: 5
AFTER:  2 + 3
AFTER:  4 + -2
AFTER:  3 + 1
```
