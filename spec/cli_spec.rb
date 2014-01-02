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
    end
  end
end
