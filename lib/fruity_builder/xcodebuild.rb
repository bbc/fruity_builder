require 'fruity_builder/lib/execution'

module FruityBuilder
  module IOS
    class XCodeBuild < Execution

      attr_accessor :path

      def initialize(path)
        @path = path
      end

      def get_schemes
        self.class.get_schemes(path)
      end

      def get_targets
        self.class.get_targets(path)
      end

      def get_build_configurations
        self.class.get_build_configurations(path)
      end

      def self.retrieve_project_section(project_info, section)
        index = project_info.index(section)
        section_values = []
        for i in index+1..project_info.count - 1
          break if project_info[i].empty?
          section_values << project_info[i]
        end
        section_values
      end

      def self.get_schemes(project_path)
        retrieve_project_section(get_project_info(project_path), 'Schemes:')
      end

      def self.get_build_configurations(project_path)
        retrieve_project_section(get_project_info(project_path), 'Build Configurations:')
      end

      def self.get_targets(project_path)
        retrieve_project_section(get_project_info(project_path), 'Targets:')
      end

      def self.get_project_info(project_path)
        info = execute("xcodebuild -project #{project_path} -list")
        raise XCodeBuildCommandError.new(info.stderr) if info.exit != 0
        info.stdout.split("\n").map { |a| a.strip }
      end
    end

    class XCodeBuildCommandError < StandardError
      def initialize(msg)
        super(msg)
      end
    end
  end
end