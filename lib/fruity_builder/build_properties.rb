require 'fruity_builder/lib/execution'
require 'fruity_builder/plistutil'

module FruityBuilder
  module IOS
    class BuildProperties < Execution

      attr_accessor :project, :properties

      def initialize(project_path)
        @project = project_path
      end

      def open_project_properties
        @properties = File.read(@project)
      end

      def properties
        open_project_properties if @properties.nil?
        @properties
      end

      def save_project_properties
        File.write(@project, properties)
      end

      def replace_bundle_id(new_bundle_id)
        path = Pathname.new(File.dirname(@project) + '/../').realdirpath.to_s
        xcode = FruityBuilder::IOS::XCodeBuild.new(File.dirname(@project))
        targets = xcode.get_targets
        project_files = Dir["#{path}/**/Info.plist"]

        files = project_files.select { |project| targets.any? { |target| project.include?("#{target}/Info.plist") } }
        files.each do |file|
          FruityBuilder::IOS::Plistutil.replace_bundle_id(new_id: new_bundle_id, file: file)
        end
      end

      def get_dev_teams
        @properties.scan(/.*DevelopmentTeam = (.*);.*/).uniq.flatten
      end

      def get_code_signing_identities
        @properties.scan(/.*CODE_SIGN_IDENTITY.*= "(.*)";.*/).uniq.flatten
      end

      def get_provision_profiles
        @properties.scan(/.*PROVISIONING_PROFILE = "(.*)";.*/).uniq.flatten
      end

      def replace_dev_team(new_dev_team)
        @properties = self.class.replace_project_data(regex: '.*DevelopmentTeam = (.*);.*', data: properties, new_value: new_dev_team)
      end

      def replace_code_sign_identity(new_identity)
        @properties = self.class.replace_project_data(regex: '.*CODE_SIGN_IDENTITY.*= "(.*)";.*', data: properties, new_value: new_identity)
      end

      def replace_provisioning_profile(new_profile)
        @properties = self.class.replace_project_data(regex: '.*PROVISIONING_PROFILE = "(.*)";.*', data: properties, new_value: new_profile)
      end

      def self.replace_project_data(options = {})
        regex = Regexp.new(options[:regex])
        replacements = options[:data].scan(regex).uniq.flatten

        result = options[:data]
        replacements.each do |to_replace|
          result = result.gsub(to_replace, options[:new_value])
        end

        result
      end
    end

    class BuildPropertiesError < StandardError
      def initialize(msg)
        super(msg)
      end
    end
  end
end
