module Unmix
  class YouTubeFullAlbum < SourceBase

    # learn
    def step_1
      info = YouTubeDLInfoGetter.new(url: source.url, title: true, description: true).perform
      source.title, source.meta_text = info[:title], info[:description]
      source.segments = YouTubeMetaToSegments.new(source: source).perform
      binding.pry
    end

    # download
    def step_2
      success = YouTubeDLDownloader.new(url: url, platform: :youtube).perform
      raise "Error downloading #{url}" unless success
    end

    # cut
    def step_3
      FileUtils.mkdir_p Unmix::export_dir(title)
      tracks.each do |track|
        FFmpegFileCutter.new(
          input: Unmix::temp_download_file_path, 
          start_time: track[:start_time],
          duration: track[:duration],
          output: track[:process_file]
        ).perform
      end
    end

    # originate
    def step_4
      cover_filepath = GoogleImagesCoverFetcher.new(query: title, min_size: "400").perform

      tracks.each do |track|
        AtomicparsleyMetadataTags.new({track: track, cover_filepath: cover_filepath}).perform
      end

      FolderOrginizer.new(
        tracks: tracks,
        folder: Unmix::export_dir(title)
      ).perform
    end
  end
end