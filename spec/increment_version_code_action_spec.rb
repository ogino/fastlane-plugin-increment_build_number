describe Fastlane::Actions::IncrementBundleVersionAction do
  describe "#run" do
    # Variable
    let(:test_path) { "/tmp/fastlane/tests/fastlane" }
    let(:fixtures_path) { "./spec/fixtures/xml" }
    let(:manifest_file) { "AndroidManifest.xml" }
    # Action parameters
    let(:manifest) { File.join(test_path, manifest_file) }

    before do
      # Create test folder
      FileUtils.mkdir_p(test_path)
      source = File.join(fixtures_path, manifest_file)
      destination = File.join(test_path, manifest_file)

      # Copy .xml fixture, as it will be modified during the test
      FileUtils.cp_r(source, destination)
    end

    after do
      FileUtils.rm_rf(test_path)
    end

    it "increment version code for specified AndroidManifest.xml." do
      expect(Fastlane::UI).to receive(:success).with("Success - Increment version code #{manifest} from 1 to 2!")
      Fastlane::Actions::IncrementVersionCodeAction.run(
        manifest: "#{manifest}",
      )
      result = File.read(File.join(test_path, manifest_file))
      expect(result).to include('android:versionCode="2" android:versionName="0.0.0"')
    end
  end
end
