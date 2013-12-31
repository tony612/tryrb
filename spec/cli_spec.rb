require 'helper'

describe TryRb::CLI do
  describe '::start' do
    before do
      TryRb::CLI.editor = "mvim"
    end
    after do
      TryRb::CLI.editor = "mvim"
    end
    it "should call system method with an EDITOR" do
      TryRb::CLI.editor = "fav_editor"
      TryRb::CLI.expects(:system).with('fav_editor', 'filepath')
      TryRb::CLI.start(["filepath"])
    end

    it "should call system method with right filepath and default editor" do
      TryRb::CLI.expects(:system).with('mvim', 'filepath')
      TryRb::CLI.start(["filepath"])
    end
  end
end
