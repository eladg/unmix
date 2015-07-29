module Unmix
  class UnmixApp

    attr_accessor :source_url
    attr_accessor :source
    attr_accessor :platform

    attr_accessor :source_options

    def initialize(options)
      @source_url = options[:source_url]
      @skip_download = options[:skip_download]


      set_source_options(options)
      set_source
    end

    def set_source_options(thor_options)
      options = {}
      options[:source_url] = thor_options[:source_url]
      options[:skip_download] = thor_options[:skip_download] if skip_download 

      @source_options = options
    end

    def set_source
      # detect_source
      # for now assume all sources are YouTube full albums
      @source = Unmix::YouTubeAlbum.new options: source_options

      # create source object
    end

    def run
      # run source application
    end
  end
end
