module Unmix
  class YouTubeMetaToSegments
    attr_accessor :segments, :youtube_title, :youtube_description

    def initialize(params)
      @youtube_description = params[:source].meta_text
      @youtube_title       = params[:source].title
      @duration            = pad_time params[:source].duration

      @segments = []
    end

    def track_name(text)
      name = text.gsub(/(\d*:\d*)|(\d*:\d*:\d*)/,'')      # remove mm:ss or hh:mm:ss
      name = name.gsub(/^\d*(\.|:|\)|\-)*/ ,'')           # remove track numbering
      name = name.gsub(/\-||/ ,'').lstrip!.rstrip!        # remove unwanted chars
    end

    def start_time(text)
      pad_time(text.match(/\d*:((\d|\d\d)|:)*/).to_s)
    end

    def set_segments_basic_info
      album_title = guess_album_from_title
      lines = youtube_description.split("\n").select{ |line| line =~ /\d:\d/ }

      lines.each_with_index do |line, index|
        segment = Segment.new
        segment.text = line
        segment.index = (index+1).to_s.rjust(2,'0')
        segment.start_time = start_time(line)
        segment.process_file = segment.process_file
        segments << segment
      end
    end

    def guess_album_from_title
      # very very bad guess for now... but we will improve this :)
      album = youtube_title.split(" ") - ["FULL","Full","full","ALBUM","Album","album"]
      album.join(" ")
    end

    def guess_artist_from_title
      # very very bad guess for now... but we will improve this :)
      youtube_title[/(?:^|(?:[.!?]\s))(\w+)/,1]
    end

    def guess_album_year_from_description
      youtube_description[/19\d\d|20\d\d/]
    end

    def set_segments_end_times
      segments.each_with_index do |segment, index|
        segment == segments.last ? 
          segment.end_time = @duration || "05:00:00" : 
          segment.end_time = pad_time(segments[index+1].start_time)
      end    
    end

    def set_segments_durations
      binding.pry

      segments.each do |segment|

        # I know it's VERY stupid but it's 5am and I'm over this stupid time crap and want to move on
        time_arr = segment.end_time.split(":")
        if time_arr.count == 2
          end_hh = 0
          end_mm = time_arr[0].to_i
          end_ss = time_arr[1].to_i
        else
          end_hh = time_arr[0].to_i
          end_mm = time_arr[1].to_i
          end_ss = time_arr[2].to_i
        end

        time_arr = segment.start_time.split(":")
        if time_arr.count == 2
          start_hh = 0
          start_mm = time_arr[0].to_i
          start_ss = time_arr[1].to_i
        else
          start_hh = time_arr[0].to_i
          start_mm = time_arr[1].to_i
          start_ss = time_arr[2].to_i
        end
        segment.duration = Time.new(1970, 1, 1, end_hh, end_mm, end_ss) - Time.new(1970, 1, 1, start_hh, start_mm, start_ss)
      end
    end


    def pad_time(time_string)
      case time_string.split(":").count
      when 1
        "00:00:" << time_string
      when 2
        "00:" << time_string
      else
        time_string
      end
    end

    def perform
      set_segments_basic_info
      set_segments_end_times
      set_segments_durations

      segments
    end
  end
end