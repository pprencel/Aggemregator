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

    # 'pusher' is system comand that sends email to me
    def notify_about_error(error_message)
      return unless Rails.env.production?

      system("echo #{error_message} | pusher")
    end
  end
end
