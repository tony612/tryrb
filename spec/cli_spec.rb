require 'helper'

describe TryRb::CLI do
  describe '::start' do
    it "should call system method with an editor" do
      TryRb::Config.instance.path = fixture_file_path('tryrbrc')
      expect(TryRb::CLI).to receive(:system).with('emacs', '~/tmp/foo/tryrb/filename.rb')
      TryRb::CLI.start(["filename"])
    end

    it "should call system method with right filepath and default editor" do
      TryRb::Config.instance.path = fixture_file_path('foorc')
      expect(TryRb::CLI).to receive(:system).with('mvim', '~/tmp/tryrb/filename.rb')
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
      expect(TryRb::CLI.fullpath('bar')).to eq('~/tmp/foo/tryrb/bar.rb')
    end
    it 'return right filename with a file *.rb' do
      expect(TryRb::CLI.fullpath('bar.rb')).to eq('~/tmp/foo/tryrb/bar.rb')
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
end
