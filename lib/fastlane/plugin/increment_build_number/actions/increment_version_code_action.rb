require "fastlane/action"
require_relative "../helper/increment_build_number_helper"

module Fastlane
  module Actions
    class IncrementVersionCodeAction < Action
      def self.run(params)
        require "nokogiri"
        require "open-uri"

        manifest = Nokogiri::XML(open(params[:manifest]))
        ver_code = manifest.xpath("//manifest").first["android:versionCode"]
        new_ver = self.number?(ver_code).nil? ? nil : ver_code.to_i + 1
        if new_ver.nil?
          UI.user_error!("Failure - Increment version code #{params[:manifest]} from #{ver_code} to #{new_ver}.")
        else
          manifest.xpath("//manifest").first["android:versionCode"] = new_ver
          File.write(params[:manifest], manifest.to_xml)
          UI.success("Success - Increment version code #{params[:manifest]} from #{ver_code} to #{new_ver}!")
        end
      end

      def self.number?(str)
        (str =~ /\A[0-9]+\z/) != nil
      end

      def self.description
        "Increment version code for Android."
      end

      def self.authors
        ["Miyabi Ogino"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Increment version code for Android."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :manifest,
                                       env_name: "FL_BUILD_NUMBER_MANIFEST",
                                       description: "optional, you must specify the path to your AndroidManifest.xml file if it is not in the project root directory",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Could not find AndroidManifest.xml") if !File.exist?(value) && !Helper.test?
                                       end),
        ]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
