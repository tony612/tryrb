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
      TryRb::CLI::Shell::Color.new.say("Please run `tryrb config` to configure.", :red)
      abort
    end

    def expanded_rc_path
      File.expand_path('~/.tryrbrc')
    end

    def expanded_tmp_dir
      File.expand_path(tmp_dir)
    end

  end
end
