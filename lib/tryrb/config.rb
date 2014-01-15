require 'singleton'

module TryRb
  class Config
    include Singleton
    attr_reader :path

    %w[tmp_dir editor].each do |key|
      define_method key.to_sym do
        @data[key]
      end
    end

    def initialize
      @path = expanded_rc_path
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

    def expanded_rc_path
      File.expand_path('~/.tryrbrc')
    end

    def expanded_tmp_dir
      File.expand_path(tmp_dir)
    end

    private

      def default_config
        {'tmp_dir' => "~/tmp/tryrb",
         'editor'  => 'mvim'}
      end
  end
end
