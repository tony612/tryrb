require 'helper'

describe TryRb::Config do
  after :each do
    # TryRb::Config.instance.reset
  end

  it 'is a singleton' do
    expect(TryRb::Config).to be_a Class
    expect do
      TryRb::Config.new
    end.to raise_error(NoMethodError, /private method `new' called/)
  end

  describe '#tmp_dir' do
    it "returns tmp dir" do
      config = TryRb::Config.instance
      config.stub(:expanded_rc_path) { fixture_file_path('tryrbrc') }
      expect(config.tmp_dir).to eq '~/tmp/foo/tryrb'
    end
  end

  describe '#editor' do
    it "returns editor" do
      config = TryRb::Config.instance
      config.stub(:expanded_rc_path) { fixture_file_path('tryrbrc') }
      expect(config.editor).to eq 'emacs'
    end
  end

  describe '#load_file' do
    context 'when file exists at path' do
      it 'loads data from the file' do
        config = TryRb::Config.instance
        config.stub(:expanded_rc_path) { fixture_file_path('tryrbrc') }
        expect(config.tmp_dir).to eq '~/tmp/foo/tryrb'
      end
    end
    context 'when file does not exist' do
      it 'reminds to config and abort' do
        config = TryRb::Config.instance
        config.stub(:expanded_rc_path) { fixture_file_path('foorc') }
        expect(config).to receive(:abort)
        expect(config).to receive(:puts).with("\e[31mPlease run `tryrb config` to configure.\e[0m")
        config.load_file
      end
    end
  end

  describe '#expanded_rc_path' do
    it 'returns right tryrbrc' do
      expect(File).to receive(:expand_path).with('~/.tryrbrc')
      TryRb::Config.instance.expanded_rc_path
    end
  end
end
