require 'fruity_builder/lib/execution'
require 'ox'

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

      # Check to ensure that plistutil is available
      # @return [Boolean] true if plistutil is available, false otherwise
      def self.plistutil_available?
        result = execute('which plistutil')
        result.exit == 0
      end

      # Gets properties from the IPA and returns them in a hash
      # @param [String] path path to the IPA/App
      # @return [Hash] list of properties from the app
      def self.get_bundle_id_from_app(path)
        path = Signing.unpack_ipa(path) if Signing.is_ipa?(path)
        get_bundle_id_from_plist("#{path}/Info.plist")
      end

      # Gets properties from the IPA and returns them in a hash
      # @param [String] plist path to the plist
      # @return [Hash] list of properties from the app
      def self.get_bundle_id_from_plist(plist)
        raise PlistutilCommandError.new('plistutil not found') unless plistutil_available?
        result = execute("plistutil -i #{plist}")
        raise PlistutilCommandError.new(result.stderr) if result.exit != 0
        parse_xml(result.stdout)
      end

      def self.parse_xml(xml)
        info = Ox.parse(xml)
        nodes = info.locate('*/dict')
        values = {}
        last_key = nil
        nodes.each do |node|
          node.nodes.each do |child|
            if child.value == 'key'
              if child.nodes.first == 'get-task-allow'
                values['get-task-allow'] = nodes.first.nodes[nodes.first.nodes.index(child)+1].value
                next
              end
              last_key = child.nodes.first
            elsif child.value == 'string'
              values[last_key] = child.nodes.first
            end
          end
        end
        values
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

