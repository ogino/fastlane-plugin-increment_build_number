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
      expect(Fastlane::UI).to receive(:success).with("Success - Increment/Change version code #{manifest} from 1 to 2 and change version name from 0.0.0 to 0.0.0!")
      Fastlane::Actions::IncrementVersionCodeAction.run(
        manifest: manifest.to_s
      )
      result = File.read(File.join(test_path, manifest_file))
      expect(result).to include('android:versionCode="2" android:versionName="0.0.0"')
    end

    it "change build number for specified AndroidManifest.xml." do
      expect(Fastlane::UI).to receive(:success).with("Success - Increment/Change version code #{manifest} from 1 to 111 and change version name from 0.0.0 to 0.0.0!")
      Fastlane::Actions::IncrementVersionCodeAction.run(
        manifest: manifest.to_s,
        version_code: "111",
        auto_increment: false
      )
      result = File.read(File.join(test_path, manifest_file))
      expect(result).to include('android:versionCode="111" android:versionName="0.0.0"')
    end

    it "renew version and build number for specified AndroidManifest.xml without auto increment build number." do
      expect(Fastlane::UI).to receive(:success).with("Success - Increment/Change version code #{manifest} from 1 to 111 and change version name from 0.0.0 to 11.0.1!")
      Fastlane::Actions::IncrementVersionCodeAction.run(
        manifest: manifest.to_s,
        version_name: "11.0.1",
        version_code: "111",
        auto_increment: false
      )
      result = File.read(File.join(test_path, manifest_file))
      expect(result).to include('android:versionCode="111" android:versionName="11.0.1"')
    end

    it "renew version and build number with auto increment for specified AndroidManifest.xml without auto increment build number." do
      expect(Fastlane::UI).to receive(:success).with("Success - Increment/Change version code #{manifest} from 1 to 100 and change version name from 0.0.0 to 1.1.1!")
      Fastlane::Actions::IncrementVersionCodeAction.run(
        manifest: manifest.to_s,
        version_name: "1.1.1",
        version_code: "99",
        auto_increment: true
      )
      result = File.read(File.join(test_path, manifest_file))
      expect(result).to include('android:versionCode="100" android:versionName="1.1.1"')
    end
  end
end
