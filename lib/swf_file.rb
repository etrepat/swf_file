$:.unshift File.join(File.dirname(__FILE__), 'swf_file') unless $:.include? File.join(File.dirname(__FILE__), 'swf_file')

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
    # TODO: improve URI/URL validation by actually checking if the resource exists (request responds)
    raise RuntimeError, "SWF file not found.", caller if !File.exists?(swf_path) && URI.extract(swf_path).empty?
    
    header = SwfHeader.new(swf_path)
    yield(header) if block_given?
    header
  end
  
  # Instance methods
  def initialize(swf_path)
    # TODO: improve URI/URL validation by actually checking if the resource exists (request responds)
    raise RuntimeError, "SWF file not found.", caller if !File.exists?(swf_path) && URI.extract(swf_path).empty?
    
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