require 'helper'

describe TryRb::CLI do
  before :each do
    Time.stub(:now) { Date.parse('2014-1-1').to_time }
  end
  describe '::start' do
    it "should call system method with an editor" do
      TryRb::Config.instance.path = fixture_file_path('tryrbrc')
      expect(TryRb::CLI).to receive(:system).with('emacs ~/tmp/foo/tryrb/20140101000000_filename.rb')
      TryRb::CLI.start(["filename"])
    end

    it "should call system method with right filepath and default editor" do
      TryRb::Config.instance.path = fixture_file_path('foorc')
      expect(TryRb::CLI).to receive(:system).with('mvim ~/tmp/tryrb/20140101000000_filename.rb')
      TryRb::CLI.start(["filename"])
    end
  end

  describe '::fullpath' do
    before :each do
      TryRb::Config.instance.path = fixture_file_path('tryrbrc')
      FileUtils.mkdir project_path + '/tmp' unless Dir.exists?(project_path + '/tmp')
    end
    after :each do
      FileUtils.rmdir project_path + '/tmp'
    end
    it 'return fullpath of the file' do
      expect(TryRb::CLI.fullpath('bar')).to eq('~/tmp/foo/tryrb/20140101000000_bar.rb')
    end
    it 'return right filename with a file *.rb' do
      expect(TryRb::CLI.fullpath('bar.rb')).to eq('~/tmp/foo/tryrb/20140101000000_bar.rb')
    end

    context 'when the Dir does not exists' do
      it 'create a dir' do
        Dir.stub(:exists?) { false }
        TryRb::Config.instance.stub(:tmp_dir) { project_path + '/tmp/tryrb' }
        expect(FileUtils).to receive(:mkdir_p).with(project_path + '/tmp/tryrb')
        TryRb::CLI.fullpath('bar')
      end
    end

    context 'when the Dir exists' do
      it 'does not create a dir' do
        Dir.stub(:exists?) { true }
        TryRb::Config.instance.stub(:tmp_dir) { project_path + '/tmp/tryrb' }
        expect(FileUtils).to_not receive(:mkdir_p).with(project_path + '/tmp/tryrb')
        TryRb::CLI.fullpath('bar')
      end
    end

    context 'when there is a file which has same name with dir' do
      it 'aborts' do
        TryRb::Config.instance.stub(:tmp_dir) { project_path + '/tmp/foo/tryrb' }
        FileUtils.touch project_path + '/tmp/foo'
        expect(TryRb::CLI).to receive(:abort).with(/File .+ exists. The tmp directory can't be created! Please delete the file first./)
        TryRb::CLI.fullpath('bar')
      end
    end
  end

  describe '#filename_prefix' do
    it "return now string" do
      expect(TryRb::CLI.filename_prefix).to eq("20140101000000")
    end
  end

  describe '#get_filename' do
    context 'when name is given' do
      it 'returns string containing the name' do
        expect(TryRb::CLI.get_filename('bar')).to eq('20140101000000_bar.rb')
      end
    end
    context 'when name is not given' do
      it 'returns just time string' do
        expect(TryRb::CLI.get_filename(nil)).to eq('20140101000000.rb')
      end
    end
  end
end
