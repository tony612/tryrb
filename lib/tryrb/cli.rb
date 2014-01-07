require 'fileutils'
require 'thor'
require 'tryrb/config'

module TryRb
  class CLI < Thor
    def initialize(*)
      @config = TryRb::Config.instance
      super
    end

    desc "create [FILENAME]", 'create a file to edit (short-cut alias: "c")'
    def create(key_name="")
      @key_name = key_name
      system([@config.editor, fullpath] * ' ')
    end

    map 'c' => :create

    option :last, aliases: "-l", banner: 'N', desc: 'open the last N file in the files you specify via filename, default is the 1', type: :numeric, lazy_default: 1
    desc "exec [FILENAME]", 'open a file to edit, default is last one of all files (short-cut alias: "e")'
    def exec(filename=nil)
      file_path = find_file(filename: filename, last_n: options[:last])
      abort "Can't find the file you want" unless file_path
      system(['ruby', file_path] * ' ')
    end

    map 'e' => :exec

    private

      def find_file(options={})
        filename = options[:filename]
        last_n   = options[:last_n] || 1
        names = Dir[File.join(@config.expanded_tmp_dir, '*.rb')]
        names = names.select { |n| n =~ /#{filename}\.rb$/ } if filename
        names[-last_n]
      end

      def fullpath
        filename = get_filename
        expanded_path = @config.expanded_tmp_dir
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
