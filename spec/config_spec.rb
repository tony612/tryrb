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
      config.path = fixture_file_path('tryrbrc')
      expect(config.tmp_dir).to eq '~/tmp/foo/tryrb'
    end
  end

  describe '#path=' do
    it 'overrides path' do
      config = TryRb::Config.instance
      config.path = fixture_file_path('foorc')
      expect(config.path).to eq fixture_file_path('foorc')
    end
    it 'reloads data' do
      config = TryRb::Config.instance
      config.path = fixture_file_path('tryrbrc')
      expect(config.load_file.keys).to eq %w[tmp_dir]
    end
  end

  describe 'load_file' do
    context 'when file exists at path' do
      it 'loads data from the file' do
        config = TryRb::Config.instance
        config.path = fixture_file_path('tryrbrc')
        expect(config.tmp_dir).to eq '~/tmp/foo/tryrb'
      end
    end
    context 'when file does not exist' do
      it 'loads default data' do
        config = TryRb::Config.instance
        config.path = fixture_file_path('foorc')
        expect(config.tmp_dir).to eq '~/tmp/tryrb'
      end
    end
  end
end
