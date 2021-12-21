require "fastlane/action"
require_relative "../helper/increment_build_number_helper"

module Fastlane
  module Actions
    class IncrementBundleVersionAction < Action
      def self.run(params)
        ver_code = Fastlane::Actions::GetInfoPlistValueAction.run(path: params[:info_plist], key: "CFBundleVersion")
        new_ver = self.number?(ver_code).nil? ? nil : ver_code.to_i + 1
        if new_ver.nil?
          UI.user_error!("Failure - Increment bundle version #{params[:info_plist]} from #{ver_code} to #{new_ver}.")
        else
          Fastlane::Actions::SetInfoPlistValueAction.run(path: params[:info_plist], key: "CFBundleVersion", value: new_ver.to_s)
          UI.success("Success - Increment bundle version #{params[:info_plist]} from #{ver_code} to #{new_ver}!")
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
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Could not find Info.plist") if !File.exist?(value) && !Helper.test?
                                       end),
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
