require 'tryrb/config'
require 'fileutils'

module TryRb
  class CLI
    @config = TryRb::Config.instance
    class << self
      attr_writer :config
      def start(args)
        system(@config.editor, fullpath(args[0]))
      end

      def fullpath(filename)
        filename = filename.gsub(/\.rb$/, '') + '.rb'
        expanded_path = File.expand_path(@config.tmp_dir)
        FileUtils.mkdir_p expanded_path unless Dir.exists?(expanded_path)
        File.join @config.tmp_dir, filename
      rescue Errno::EEXIST => e
        abort "File #{e.message.split[-1]} exists. The tmp directory can't be created! Please delete the file first."
      end
    end
  end
end
