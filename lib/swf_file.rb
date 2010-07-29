$:.unshift File.join(File.dirname(__FILE__), 'swf_file') unless $:.include? File.join(File.dirname(__FILE__), 'swf_file')

require 'net/http'
require 'uri'
require 'open-uri'
require 'zlib'
require 'parser'
require 'compression'
require 'conversions'
require 'assertions'
require 'packed_bit_object'
require 'swf_header'

class SwfFile
  # Class methods
  def self.header(swf_path)
    raise RuntimeError, "SWF file not found.", caller if !self.swf_exists?(swf_path)

    header = SwfHeader.new(swf_path)
    yield(header) if block_given?
    header
  end

  def self.swf_exists?(swf_path)
    return true if File.exists?(swf_path)

    begin
      case Net::HTTP.get_response(URI.parse(swf_path))
        when Net::HTTPSuccess
          true
        else
          false
      end
    rescue Exception => e
      false
    end
  end

  # Instance methods
  def initialize(swf_path)
    raise RuntimeError, "SWF file not found.", caller if !SwfFile.swf_exists?(swf_path)

    @header = SwfHeader.new(swf_path)
  end

  def header
    yield(@header) if block_given?
    @header
  end

  def compressed?
    @header.compressed?
  end
end

