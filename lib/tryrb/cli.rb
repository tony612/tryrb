require 'fileutils'
require 'thor'
require 'tryrb/config'

module TryRb
  class CLI < Thor
    def initialize(*)
      @config = TryRb::Config.instance
      super
    end

    desc "open [FILENAME]", 'open a file to edit (short-cut alias: "o")'
    def open(key_name="")
      @key_name = key_name
      system([@config.editor, fullpath] * ' ')
    end

    map 'o' => :open

    private

      def fullpath
        filename = get_filename
        expanded_path = File.expand_path(@config.tmp_dir)
        FileUtils.mkdir_p expanded_path unless Dir.exists?(expanded_path)
        File.join @config.tmp_dir, filename
      rescue Errno::EEXIST => e
        abort "File #{e.message.split[-1]} exists. The tmp directory can't be created! Please delete the file first."
      end

      def filename_prefix
        Time.now.strftime("%Y%m%d%H%M%S")
      end

      def filename_extname
        '.rb'
      end

      def get_filename
        parts = [filename_prefix]
        parts << @key_name.gsub(/\.rb$/, '') unless @key_name.empty?
        parts * '_' + filename_extname
      end
  end
end
