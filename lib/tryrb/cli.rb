require 'tryrb/config'

module TryRb
  class CLI
    @editor = "mvim"
    class << self
      attr_accessor :editor
      def start(args)
        system(@editor, args[0])
      end
    end
  end
end
