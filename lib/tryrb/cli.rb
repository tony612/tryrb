require 'tryrb/config'
require 'fileutils'

module TryRb
  class CLI
    @config = TryRb::Config.instance
    class << self
      attr_writer :config
      def start(args)
        system([@config.editor, fullpath(args[0])] * ' ')
      end

      def fullpath(filename)
        filename = get_filename(filename)
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

      def get_filename(name)
        parts = [filename_prefix]
        parts << name.gsub(/\.rb$/, '') if name
        parts * '_' + filename_extname
      end
    end
  end
end
