require 'fruity_builder/lib/sys_log'
require 'fruity_builder/xcodebuild'
require 'fruity_builder/build_properties'


module FruityBuilder
  module IOS

    attr_accessor :log

    @@log = FruityBuilder::SysLog.new

    def self.log
      @@log
    end

    def self.set_logger(log)
      @@log = log
    end

    class Helper

    attr_accessor :path, :project, :workspace, :build, :plist, :xcode

    def initialize(path)
      @path = path
    end

    def project
      if @project.nil?
        if @path.scan(/.*xcodeproj$/).count > 0
          return @path
        end
        projects = Dir["#{@path}/**/*.xcodeproj"]
        projects = projects.select { |project| !project.include?('Pods')}
        raise HelperCommandError.new('Project not found') if projects.empty?
        raise HelperCommandError.new('Mulitple projects found, please specify one') if projects.count > 1
        project = projects.first
        @project = project
      end
      @project
    end

    def workspace
      if @workspace.nil?
        if @path.scan(/.*xcworkspace$/).count > 0
          return @path
        end
        workspace = Dir["#{@path}/**/*.xcworkspace"].first
        raise 'Workspace not found' if workspace.nil?
        @workspace = workspace
      end
      @workspace
    end

    # Handle for the BuildProperties class
    def build
      if @build.nil?
        @build = FruityBuilder::IOS::BuildProperties.new("#{project}/project.pbxproj")
      end
      @build
    end

    # Handle for the XCodeBuild class
    def xcode
      if @xcode.nil?
        @xcode = FruityBuilder::IOS::XCodeBuild.new(project)
      end
      @xcode
    end
    end
  end

  class HelperCommandError < StandardError
    def initialize(msg)
      super(msg)
    end
  end
end