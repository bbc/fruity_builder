require 'fruity_builder/lib/execution'

module FruityBuilder
  module IOS
    class Plistutil < Execution

      def self.get_xml(options = {})
        if options.key?(:file)
          IO.read(options[:file])
        elsif options.key?(:xml)
          options[:xml]
        end
      end

      def self.get_bundle_id(options = {})
        xml = get_xml(options)

        raise PlistutilCommandError.new('No XML was passed') unless xml

        identifiers = xml.scan(/.*CFBundleIdentifier<\/key>\n\t<string>(.*?)<\/string>/)
        identifiers << xml.scan(/.*CFBundleName<\/key>\n\t<string>(.*?)<\/string>/)

        identifiers.flatten.uniq
      end

      def self.replace_bundle_id(options = {})
        xml = get_xml(options)

        raise PlistutilCommandError.new('No XML was passed') unless xml

        replacements = xml.scan(/.*CFBundleIdentifier<\/key>\n\t<string>(.*?)<\/string>/)
        replacements << xml.scan(/.*CFBundleName<\/key>\n\t<string>(.*?)<\/string>/)

        replacements.flatten.uniq.each do |replacement|
          xml = xml.gsub(replacement, options[:new_id])
        end

        IO.write(options[:file], xml) if options.key?(:file)
        xml
      end
    end

    # plistutil error class
    class PlistutilCommandError < StandardError
      def initialize(msg)
        super(msg)
      end
    end
  end
end