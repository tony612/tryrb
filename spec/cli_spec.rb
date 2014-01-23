require 'helper'

describe TryRb::CLI do
  before :each do
    Time.stub(:now) { Date.parse('2014-1-1').to_time }
    TryRb::Config.instance.path = fixture_file_path('tryrbrc')
    @cli = TryRb::CLI.new
  end

  describe '#create' do
    it 'create a file 20140101000000.rb' do
      expect(@cli).to receive(:system).with('emacs ~/tmp/foo/tryrb/20140101000000.rb')
      @cli.create
    end
    it 'create a file 20140101000000_foo.rb' do
      expect(@cli).to receive(:system).with('emacs ~/tmp/foo/tryrb/20140101000000_foo.rb')
      @cli.create 'foo'
    end
  end

  describe '#exec' do
    before :each do
      FakeFS.activate!
      FileUtils.mkdir_p '/tmp/foo/tryrb'
      FileUtils.touch '/tmp/foo/tryrb/20140101000000_foo.rb'
      FileUtils.touch '/tmp/foo/tryrb/20140102000000_foo.rb'
      FileUtils.touch '/tmp/foo/tryrb/20140103000000_bar.rb'
      expect(TryRb::Config.instance).to receive(:expanded_tmp_dir).and_return('/tmp/foo/tryrb')
    end
    after :each do
      FileUtils.rm_rf '/tmp/foo'
      FakeFS.deactivate!
    end
    it 'exec last file' do
      expect(@cli).to receive(:system).with('ruby /tmp/foo/tryrb/20140103000000_bar.rb')
      @cli.exec
    end
    it 'exec last file with filename' do
      expect(@cli).to receive(:system).with('ruby /tmp/foo/tryrb/20140102000000_foo.rb')
      @cli.exec 'foo'
    end
    it 'exec last second file' do
      expect(@cli).to receive(:options).and_return({:last => 2})
      expect(@cli).to receive(:system).with('ruby /tmp/foo/tryrb/20140102000000_foo.rb')
      @cli.exec
    end
    it 'exec last second file with filename' do
      expect(@cli).to receive(:options).and_return({:last => 2})
      expect(@cli).to receive(:system).with('ruby /tmp/foo/tryrb/20140101000000_foo.rb')
      @cli.exec 'foo'
    end
    it 'abort because there is no file' do
      @cli.stub(:system)
      expect(@cli).to receive(:options).and_return({:last => 4})
      expect(@cli).to receive(:abort).with("Can't find the file you want")
      @cli.exec
    end
  end

  describe '#config' do
    before :each do
      @shell = TryRb::CLI::Shell::Basic.new
      FakeFS.activate!
    end
    after :each do
      FileUtils.rm '/tmp/.tryrbrc'
      FakeFS.deactivate!
    end
    it "save config data in tryrbrc" do
      cli = TryRb::CLI.new
      expect(TryRb::Config.instance).to receive(:expanded_rc_path).and_return('/tmp/.tryrbrc')
      expect(cli).to receive(:ask).with("Please specify your dir of the tmp files(default: ~/tmp/tryrb):").and_return('~/foo/tryrb')
      expect(cli).to receive(:ask).with("Please specify your favorite editor(default: vim):").and_return('emacs')
      cli.config
      if RUBY_VERSION < '2.1.0'
        expect(File.open('/tmp/.tryrbrc').read).to eq("---\ntmp_dir: ~/foo/tryrb\neditor: emacs\n")
      else
        expect(File.open('/tmp/.tryrbrc').read).to eq("---\ntmp_dir: \"~/foo/tryrb\"\neditor: emacs\n")
      end
    end
  end
end
