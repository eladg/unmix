class Track
  attr_accessor :title
  attr_accessor :artist
  attr_accessor :album
  attr_accessor :artist_album
  attr_accessor :genre
  attr_accessor :year
  attr_accessor :track_number
  attr_accessor :tracks_count

  # the assosiated track's segment
  attr_reader :segment
end