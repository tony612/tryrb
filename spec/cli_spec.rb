require 'helper'

describe TryRb::CLI do
  before :each do
    Time.stub(:now) { Date.parse('2014-1-1').to_time }
    TryRb::Config.instance.path = fixture_file_path('tryrbrc')
    @cli = TryRb::CLI.new
  end

  describe '#open' do
    it 'open a file 201401010000.rb' do
      expect(@cli).to receive(:system).with('emacs ~/tmp/foo/tryrb/20140101000000.rb')
      @cli.open
    end
    it 'open a file 20140101000000_foo.rb' do
      expect(@cli).to receive(:system).with('emacs ~/tmp/foo/tryrb/20140101000000_foo.rb')
      @cli.open 'foo'
    end
  end
end
