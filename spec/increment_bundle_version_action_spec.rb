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

    it "increment build number for specified Info.plist." do
      expect(Fastlane::UI).to receive(:success).with("Success - Increment/Change bundle version #{plist} from 1 to 2 and change version from 0.0.0 to 0.0.0!")
      Fastlane::Actions::IncrementBundleVersionAction.run(
        info_plist: plist.to_s
      )
      result = File.read(File.join(test_path, plist_file))
      expect(result).to include("<key>CFBundleVersion</key>")
      expect(result).to include("<string>2</string>")
      expect(result).to match(%r{<key>CFBundleVersion</key>\n\s+<string>2</string>\n})
    end

    it "change build number for specified Info.plist." do
      expect(Fastlane::UI).to receive(:success).with("Success - Increment/Change bundle version #{plist} from 1 to 111 and change version from 0.0.0 to 0.0.0!")
      Fastlane::Actions::IncrementBundleVersionAction.run(
        info_plist: plist.to_s,
        build_number: "111",
        auto_increment: false
      )
      result = File.read(File.join(test_path, plist_file))
      expect(result).to include("<key>CFBundleVersion</key>")
      expect(result).to include("<string>111</string>")
      expect(result).to match(%r{<key>CFBundleVersion</key>\n\s+<string>111</string>\n})
    end

    it "renew version and build number for specified Info.plist without auto increment build number." do
      expect(Fastlane::UI).to receive(:success).with("Success - Increment/Change bundle version #{plist} from 1 to 11 and change version from 0.0.0 to 100.0.0!")
      Fastlane::Actions::IncrementBundleVersionAction.run(
        info_plist: plist.to_s,
        version_number: "100.0.0",
        build_number: "11",
        auto_increment: false
      )
      result = File.read(File.join(test_path, plist_file))
      expect(result).to include("<key>CFBundleShortVersionString</key>")
      expect(result).to include("<string>100.0.0</string>")
      expect(result).to match(%r{<key>CFBundleShortVersionString</key>\n\s+<string>100.0.0</string>\n})
      expect(result).to include("<key>CFBundleVersion</key>")
      expect(result).to include("<string>11</string>")
      expect(result).to match(%r{<key>CFBundleVersion</key>\n\s+<string>11</string>\n})
    end

    it "renew version and build number with auto increment for specified Info.plist without auto increment build number." do
      expect(Fastlane::UI).to receive(:success).with("Success - Increment/Change bundle version #{plist} from 1 to 11 and change version from 0.0.0 to 1.0.0!")
      Fastlane::Actions::IncrementBundleVersionAction.run(
        info_plist: plist.to_s,
        version_number: "1.0.0",
        build_number: "10",
        auto_increment: true
      )
      result = File.read(File.join(test_path, plist_file))
      expect(result).to include("<key>CFBundleShortVersionString</key>")
      expect(result).to include("<string>1.0.0</string>")
      expect(result).to match(%r{<key>CFBundleShortVersionString</key>\n\s+<string>1.0.0</string>\n})
      expect(result).to include("<key>CFBundleVersion</key>")
      expect(result).to include("<string>11</string>")
      expect(result).to match(%r{<key>CFBundleVersion</key>\n\s+<string>11</string>\n})
    end
  end
end
