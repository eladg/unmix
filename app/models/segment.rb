class Segment
  attr_accessor :text
  attr_accessor :process_file
  attr_accessor :index
  attr_accessor :duration
  attr_accessor :start_time
  attr_accessor :end_time

  def process_file
    @process_file ||= "#{Unmix.process_dir}/#{SecureRandom.urlsafe_base64(4)}.m4a"
  end
end