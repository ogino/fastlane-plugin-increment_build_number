describe Fastlane::Actions::IncrementVersionCodeAction do
  describe "#run" do
    # Variable
    let(:test_path) { "/tmp/fastlane/tests/fastlane" }
    let(:fixtures_path) { "./spec/fixtures/plist" }
    let(:plist_file) { "Info.plist" }
    # Action parameters
    let(:plist) { File.join(test_path, plist_file) }

    before do
      # Create test folder
      FileUtils.mkdir_p(test_path)
      source = File.join(fixtures_path, plist_file)
      destination = File.join(test_path, plist_file)

      # Copy .plist fixture, as it will be modified during the test
      FileUtils.cp_r(source, destination)
    end

    after do
      FileUtils.rm_rf(test_path)
    end

    it "increment bundle version for specified Info.plist." do
      expect(Fastlane::UI).to receive(:success).with("Success - Increment bundle version #{plist} from 1 to 2!")
      Fastlane::Actions::IncrementBundleVersionAction.run(
        plist: "#{plist}",
        )
      result = File.read(File.join(test_path, plist_file))
      expect(result).to include("<key>CFBundleVersion</key>")
      expect(result).to include("<string>2</string>")
      expect(result).to match(/<key>CFBundleVersion<\/key>\n\s+<string>2<\/string>\n/)
    end
  end
end
