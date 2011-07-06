module SwfFile

  class FlashFile
    # Class methods
    def self.header(swf_path)
      raise RuntimeError, "SWF file not found.", caller unless self.swf_exists?(swf_path)

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
      raise RuntimeError, "SWF file not found.", caller unless self.class.swf_exists?(swf_path)

      @header = SwfHeader.new(swf_path)
    end

    def header
      yield(@header) if block_given?
      @header
    end

    def compressed?
      @header.compressed?
    end
  end # FlashFile

end # SwfFile

