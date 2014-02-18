require 'singleton'

module TryRb
  class Config
    include Singleton

    %w[tmp_dir editor].each do |key|
      define_method key.to_sym do
        data[key]
      end
    end

    def data
      @data ||= load_file
    end

    def load_file
      require 'yaml'
      YAML.load_file(expanded_rc_path)
    rescue Errno::ENOENT
      print_red("Please run `tryrb config` to configure.")
      abort
    end

    def expanded_rc_path
      File.expand_path('~/.tryrbrc')
    end

    def expanded_tmp_dir
      File.expand_path(tmp_dir)
    end

    private
      def print_red(str)
        puts "\e[31m#{str}\e[0m"
      end
  end
end
