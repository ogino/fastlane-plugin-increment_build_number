require "fastlane/action"
require_relative "../helper/increment_build_number_helper"

module Fastlane
  module Actions
    class IncrementBundleVersionAction < Action
      def self.run(params)
        org_version = Fastlane::Actions::GetInfoPlistValueAction.run(path: params[:info_plist], key: "CFBundleShortVersionString")
        version = params[:version_number] || org_version
        org_build = Fastlane::Actions::GetInfoPlistValueAction.run(path: params[:info_plist], key: "CFBundleVersion")
        build = params[:build_number] || org_build
        auto_increment = params[:auto_increment].nil? ? true : params[:auto_increment]
        new_build = if self.number?(build).nil?
                      nil
                    else
                      auto_increment ? build.to_i + 1 : build.to_i
                    end
        if new_build.nil?
          UI.user_error!("Failure - Increment/Change bundle version #{params[:info_plist]} from #{org_build} to #{new_build} and change version from #{org_version} to #{version}.")
        else
          Fastlane::Actions::SetInfoPlistValueAction.run(path: params[:info_plist], key: "CFBundleShortVersionString", value: version.to_s)
          Fastlane::Actions::SetInfoPlistValueAction.run(path: params[:info_plist], key: "CFBundleVersion", value: new_build.to_s)
          UI.success("Success - Increment/Change bundle version #{params[:info_plist]} from #{org_build} to #{new_build} and change version from #{org_version} to #{version}!")
        end
      end

      def self.number?(str)
        (str =~ /\A[0-9]+\z/) != nil
      end

      def self.description
        "Increment bundle version for iOS."
      end

      def self.authors
        ["Miyabi Ogino"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Increment bundle version for iOS."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :info_plist,
                                       env_name: "FL_BUILD_NUMBER_INFO_PLIST",
                                       description: "optional, you must specify the path to your Info.plist file if it is not in the project root directory",
                                       type: String,
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Could not find Info.plist") if !File.exist?(value) && !Helper.test?
                                       end),
          FastlaneCore::ConfigItem.new(key: :version_number,
                                       env_name: "FL_INCREMENT_BUILD_NUMBER_VERSION_NUMBER",
                                       description: "Change to a specific version number. This will replace the bump type value",
                                       type: String,
                                       optional: true,
                                       skip_type_validation: true),
          FastlaneCore::ConfigItem.new(key: :build_number,
                                       env_name: "FL_INCREMENT_BUILD_NUMBER_BUILD_NUMBER",
                                       description: "Change to a specific build number",
                                       type: String,
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
        [:ios, :mac].include?(platform)
      end
    end
  end
end
