require 'singleton'

module TryRb
  class Config
    include Singleton
    attr_reader :path
    FILE_NAME = '.tryrbrc'

    def initialize
      @path = File.join(File.expand_path('~'), FILE_NAME)
      @data = load_file
    end

    def tmp_dir
      @data['tmp_dir']
    end

    def path=(path)
      @path = path
      @data = load_file
      @path
    end

    def load_file
      require 'yaml'
      YAML.load_file(@path)
    rescue Errno::ENOENT
      default_config
    end

    private

      def default_config
        {'tmp_dir' => "~/tmp/tryrb"}
      end
  end
end
