module Unmix
  class SourceBase

    attr_accessor :source

    def initialize(params)
      @source = Source.new
      @source.platform = params[:platform].to_sym
      @source.url = params[:url]

      # app settings
      Unmix::set_platform_settings source.platform
    end

    def step_1
      raise "Unimplemented Source base method"
    end

    def step_2
      raise "Unimplemented Source base method"
    end

    def step_3
      raise "Unimplemented Source base method"
    end

    def step_4
      raise "Unimplemented Source base method"
    end

    def run
      puts "Step 1: Analyzing url: #{source.url}".green
      step_1
      
      puts "Found the following information:".green
      tp tracks, :index, :title, :duration, :start_time, :end_time
      puts ""

      puts "Donwloading.".green
      step_2

      # cut the video file into pieces
      puts "Cutting Video File.".green
      step_3

      # orginize the cuted files into an album folder
      puts "Orginizing Into an Album Folder.".green
      step_4

      puts "All Done!".green      
    end

  end
end