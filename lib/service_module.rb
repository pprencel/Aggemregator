module ServiceModule
  module Callable
    def call(*args, **kwargs)
      new.call(*args, **kwargs).tap do |result|
        return yield(result) if block_given?
      end
    end
  end

  module Base
    def self.prepended(base)
      class << base
        prepend Callable
      end
    end
  end
end
