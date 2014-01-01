require 'helper'

describe TryRb::CLI do
  describe '::start' do
    around :each do
      TryRb::CLI.editor = "mvim"
    end
    it "should call system method with an EDITOR" do
      TryRb::CLI.editor = "fav_editor"
      expect(TryRb::CLI).to receive(:system).with('fav_editor', 'filepath')
      TryRb::CLI.start(["filepath"])
    end

    it "should call system method with right filepath and default editor" do
      expect(TryRb::CLI).to receive(:system).with('mvim', 'filepath')
      TryRb::CLI.start(["filepath"])
    end
  end
end
