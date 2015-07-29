class Source
  attr_accessor :platform
  attr_accessor :url
  attr_accessor :title
  attr_accessor :meta_text
  attr_accessor :duration

  attr_accessor :segments

  def initialize
    segments = []    
  end
end