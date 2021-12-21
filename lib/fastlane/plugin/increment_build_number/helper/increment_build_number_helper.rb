require "fastlane_core/ui/ui"

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class IncrementBuildNumberHelper
      # class methods that you define here become available in your action
      # as `Helper::IncrementBuildNumberHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the increment_build_number plugin helper!")
      end
    end
  end
end
