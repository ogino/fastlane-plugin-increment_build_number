require "fastlane/action"
require_relative "../helper/increment_build_number_helper"

module Fastlane
  module Actions
    class IncrementVersionCodeAction < Action
      def self.run(params)
        require "nokogiri"
        require "open-uri"

        manifest = Nokogiri::XML(File.open(params[:manifest]))
        org_name = manifest.xpath("//manifest").first["android:versionName"]
        ver_name = params[:version_name] || org_name
        org_code = manifest.xpath("//manifest").first["android:versionCode"]
        ver_code = params[:version_code] || org_code
        auto_increment = params[:auto_increment].nil? ? true : params[:auto_increment]
        new_code = if self.number?(ver_code).nil?
                     nil
                   else
                     auto_increment ? ver_code.to_i + 1 : ver_code.to_i
                   end
        if new_code.nil?
          UI.user_error!("Failure - Increment/Change version code #{params[:manifest]} from #{org_code} to #{new_code} and change version name from #{org_name} to #{ver_name}.")
        else
          manifest.xpath("//manifest").first["android:versionName"] = ver_name
          manifest.xpath("//manifest").first["android:versionCode"] = new_code
          File.write(params[:manifest], manifest.to_xml)
          UI.success("Success - Increment/Change version code #{params[:manifest]} from #{org_code} to #{new_code} and change version name from #{org_name} to #{ver_name}!")
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
                                       env_name: "FL_INCREMENT_BUILD_NUMBER_MANIFEST",
                                       description: "optional, you must specify the path to your AndroidManifest.xml file if it is not in the project root directory",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Could not find AndroidManifest.xml") if !File.exist?(value) && !Helper.test?
                                       end),
          FastlaneCore::ConfigItem.new(key: :version_name,
                                       env_name: "FL_INCREMENT_BUILD_NUMBER_VERSION_NAME",
                                       description: "Change to a specific version name. This will replace the bump type value",
                                       optional: true,
                                       skip_type_validation: true),
          FastlaneCore::ConfigItem.new(key: :version_code,
                                       env_name: "FL_INCREMENT_BUILD_NUMBER_VERSION_CODE",
                                       description: "Change to a specific version code.",
                                       optional: true,
                                       skip_type_validation: true),
          FastlaneCore::ConfigItem.new(key: :auto_increment,
                                       env_name: "FL_INCREMENT_BUILD_NUMBER_AUTO_INCREMENT",
                                       description: "Auto increment version code from your AndroidManifest.xml's original version code",
                                       type: Boolean,
                                       optional: true,
                                       default_value: true)
        ]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
