require 'fileutils'
require 'thor'
require 'tryrb/config'

module TryRb
  class CLI < Thor
    def initialize(*)
      super
    end

    no_commands do
      def conf
        TryRb::Config.instance
      end
    end

    desc "create [FILENAME]", 'create a file to edit (short-cut alias: "c")'
    def create(key_name="")
      @key_name = key_name
      system([conf.editor, fullpath] * ' ')
    end
    map 'c' => :create

    option :last, :aliases => "-l", :banner => 'N', :desc => 'execute the last N file in the files you specify via filename, default is the 1', :type => :numeric, :lazy_default => 1
    desc "exec [FILENAME]", 'execute a ruby script, default is last one of all files (short-cut alias: "e")'
    def exec(filename=nil)
      file_path = find_file(:filename => filename, :last_n => options[:last])
      abort "Can't find the file you want" unless file_path
      system(['ruby', file_path] * ' ')
    end
    map 'e' => :exec

    desc 'config', "Config your editor and tmp_dir via command"
    def config
      default_tmp_path = "~/tmp/tryrb"
      tmp_dir = ask("Please specify your dir of the tmp files(default: #{default_tmp_path}):")
      tmp_dir = default_tmp_path if tmp_dir.empty?

      default_editor = "vim"
      editor = ask("Please specify your favorite editor(default: #{default_editor}):")
      editor = default_editor if editor.empty?

      config = {'tmp_dir' => tmp_dir, 'editor' => editor}

      rc_path = conf.expanded_rc_path
      File.open(rc_path, 'w') do |f|
        f.write(config.to_yaml)
      end

      say("The config have been writen to ~/.tryrbrc", :green)
    end

    private

      def find_file(options={})
        filename = options[:filename]
        last_n   = options[:last_n] || 1
        names = Dir[File.join(conf.expanded_tmp_dir, '*.rb')]
        names = names.select { |n| n =~ /#{filename}\.rb$/ } if filename
        names[-last_n]
      end

      def fullpath
        filename = get_filename
        expanded_path = conf.expanded_tmp_dir
        FileUtils.mkdir_p expanded_path unless Dir.exists?(expanded_path)
        File.join conf.tmp_dir, filename
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
