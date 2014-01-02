require 'singleton'

module TryRb
  class Config
    include Singleton
    attr_reader :path
    FILE_NAME = '.tryrbrc'

    %w[tmp_dir editor].each do |key|
      define_method key.to_sym do
        @data[key]
      end
    end

    def initialize
      @path = File.join(File.expand_path('~'), FILE_NAME)
      @data = load_file
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
        {'tmp_dir' => "~/tmp/tryrb",
         'editor'  => 'mvim'}
      end
  end
end
