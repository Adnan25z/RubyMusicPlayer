require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)

# Defines the Zorder for the gosu
module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

# Defines the Genre for the gosu
module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Hip-hop', 'Rock', 'Jazz']

# Defines the Genre for the gosu
class Track
  attr_accessor :name, :location, :track_key

  def initialize(name, location, track_key)
    @name = name
    @location = location
    @track_key = track_key
  end
end
# This is a class for an album
class Album
  attr_accessor :title, :artist, :genre, :tracks, :key, :artwork

  def initialize(title, artist, genre, tracks, key, artwork)
    @title = title
    @artist = artist
    @genre = genre
    @tracks = tracks
    @key = key
    @artwork = artwork
  end
end

# This is a class for an album
class ArtWork
  attr_accessor :bmp

  def initialize(file)
    @bmp = Gosu::Image.new(file)
  end
end

# Put your record definitions here
class MusicPlayerMain < Gosu::Window
  def initialize
    super 1000, 600
    self.caption = 'Music Player'
    @ALBUM_PAGINATION_LENGTH = 2
    @album_current_page = 1
    @number_of_pages = ((@albums.length - 1 + @ALBUM_PAGINATION_LENGTH) / @ALBUM_PAGINATION_LENGTH).to_i
    @paginated_albums = paginate_albums
    music_file = File.new('file.txt', 'r')
    albums = read_albums(music_file)
    @albums = albums
    @track_font = Gosu::Font.new(20)
    @image_color = Gosu::Color.new(0xffffffff)
    @info_font = Gosu::Font.new(30)
    @background1 = Gosu::Color.new(0xff1D252C)
    @background = Gosu::Color.new(0xff1D252C)
    @background3 = Gosu::Color.new(0xff171D23)
    # Reads in an array of albums from a file
  end

  def paginate_albums
    input = @albums
    i = (@album_current_page * @ALBUM_PAGINATION_LENGTH) - @ALBUM_PAGINATION_LENGTH
    current_page_albums = Array.new()
    while(i<@ALBUM_PAGINATION_LENGTH * @album_current_page && i < input.length)
      current_page_albums << input[i]
      i+=1
    end
    @paginated_albums = current_page_albums
    current_page_albums
  end

  def read_albums(file)
    @album_key = 1
    number_of_albums = file.gets.to_i
    albums = Array.new()
    i = 0
    while i < number_of_albums
      albums << read_album(file)
      i += 1
      @album_key += 1
    end
    albums
  end

  def read_album(file)
    album_title = file.gets
    album_artist = file.gets
    album_genre = file.gets
    album_artwork = ArtWork.new(file.gets.chomp)
    album_tracks = read_tracks(file)
    album_kay = @album_key
    album = Album.new(album_title, album_artist, album_genre, album_tracks, album_kay, album_artwork)
    album
  end

  def read_tracks(file)
    @index_track_key = 1
    @count = file.gets.to_i
    tracks = Array.new()
    i = 0
    while i < @count
      track = read_track(file)
      tracks << track
      i += 1
      @index_track_key+=1
    end
    return tracks
  end

  # reads in a single track from the given file.
  def read_track(file)
    name = file.gets
    location = file.gets
    track_kay = @index_track_key
    Track.new(name, location, track_kay)
  end
  # Draws the artwork on the screen for all the albums

  def draw_albums(albums)
    index = 0
    x1 = 90
    y1 = 100
    x2 = 290
    y2 = 300
    while index < albums.length
      if index == 1
        x1 += 290
        x2 += 290
      elsif index == 2
        x1 = 90
        x2 = 290
        y1 += 220
        y2 += 220
      elsif index==3
        x1+=290
        x2+=290
      end
      albums[index].artwork.bmp.draw_as_quad(x1, y1, @image_color, x2, y1, @image_color, x1, y2, @image_color, x2, y2, @image_color,ZOrder::PLAYER)
      index+=1
    end
  end

  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track. returns true or false
  def area_clicked(leftX, topY, rightX, bottomY)
    if @albums.length == 1
      if ((leftX > 90 and topY > 100) and (rightX < 290 and bottomY < 300))
        true
      else
        false
      end
    elsif @albums.length == 2
      if ((leftX > 90 and rightX < 290) and (topY > 100 and bottomY < 300))
        true
      elsif((leftX > 380 and rightX < 580) and (topY > 100 and bottomY < 300))
        true
      else
        false
      end
    elsif @albums.length == 3
      if ((leftX > 90 and rightX < 290) and (topY > 100 and bottomY < 300))
        true
      elsif((leftX > 380 and rightX < 580) and (topY > 100 and bottomY < 300))
        true
      elsif ((leftX > 90 and rightX < 290) and (topY > 350 and bottomY < 520))
        true
      else
        false
      end
    elsif @albums.length == 4
      if ((leftX > 90 and rightX < 290) and (topY > 100 and bottomY < 300))
        true
      elsif((leftX > 380 and rightX < 580) and (topY > 100 and bottomY < 300))
        true
      elsif ((leftX > 90 and rightX < 290) and (topY > 350 and bottomY < 520))
        true
      elsif((leftX > 380 and rightX < 580) and (topY > 350 and bottomY < 520))
        true
      else
        false
      end
    end
    return @choice
  end

  def track_area_clicked(leftX, topY, rightX, bottomY)
    i = 0
    x1 = 690
    x2 = 1000
    y1 = 0
    y2 = 40
    while i < @albums[@choice].tracks.length
      if((leftX > x1) and (topY > y1) and (rightX < x2) and (bottomY < y2))
        return i.to_i
      end
      y1+=35
      y2+=35
      i+=1
    end
  end

  def draw_btns()
    @bmp = Gosu::Image.new('images/buttons1.png')
    @bmp.draw(160 , 525, ZOrder::UI)
  end

  def btn_click(x1,x2,y1,y2)
    if((x1 > 190 and x2 < 250 ) and (y1 > 535 and y2 < 597))
      @song.play
    end
    if((x1 > 296 and x2 < 358 ) and (y1 > 535 and y2 < 597))
      @song.pause
    end
    if((x1 > 410 and x2 < 467 ) and (y1 > 535 and y2 < 597))
      @song.stop
      @choice = nil
    end
  end

  # Takes a String title and an Integer ypos
  def display_track(title, ypos)
    @track_font.draw_text(title,735 , ypos, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
  end

  def display_tracks()
    count = 0
    ypos = 12
    ypos1 = 110
    spam = @track_result.to_i + 1
    if (@choice == nil)
      while count < @albums.length
        @info_font.draw_text("#{@albums[count].title}", 710 , ypos1, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
        count+=1
        ypos1+=105
      end
    else
      while count < @albums[@choice].tracks.length
        display_track(@albums[@choice].tracks[count].name, ypos)
        if(@albums[@choice].tracks[count].track_key == spam)
          @track_font.draw_text("\u{25ba}", 720 , ypos, ZOrder::UI, 0.5, 1.0, Gosu::Color.new(0xFF099FFF))
        end
        ypos += 35
        count += 1
      end
    end
  end

  # Takes a track index and an Album and plays the Track from the Album
  def play_track(track, album)
      @song = Gosu::Song.new(album.tracks[track].location.chomp)
      @song.play(false)
  end

  # Draw a coloured background using TOP_COLOR and BOTTOM_/COLOR
  def draw_background
    draw_line(690 ,0, Gosu::Color.new(0xFF099FFF), 690, 600, Gosu::Color.new(0xFF00FF66), ZOrder::PLAYER)
    Gosu.draw_rect(0, 0, 1000, 600, @background1 , ZOrder::BACKGROUND)
  end

  # Not used since Everything depends on mouse actions.
  def update()
  end

  def draw_stuff()
    i = 0
    x1 = 0
    x2 = 60
    while i < 15
      draw_quad(690,x1, @background ,1000,x1, @background ,690,x2,@background ,1000,x2, @background , ZOrder::PLAYER)#House
      x1+=35
      x2+=35
      draw_quad(690,x1, @background3 ,1000,x1, @background3 ,690,x2,@background3 ,1000,x2, @background3 , ZOrder::PLAYER)#House
      x1+=35
      x2+=35
      i+=1
    end
  end

  # Draws the album images and the track list for the selected album
  def draw
    draw_btns()
    display_tracks()
    draw_stuff()
    draw_background()
    draw_albums(@albums)
    @track_font.draw_text("mouse_x: #{mouse_x}", 200, 50, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    @track_font.draw_text("mouse_y: #{mouse_y}", 350, 50, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
  end

  def needs_cursor?
    true
  end

  def button_down(id)
    area_clicked(mouse_x, mouse_y, mouse_x, mouse_y)
    @track_result=track_area_clicked(mouse_x, mouse_y, mouse_x, mouse_y)
    btn_click(mouse_x, mouse_x, mouse_y, mouse_y)
    case id
    when Gosu::MsLeft
      unless (@track_result.nil?)
      play_track(@track_result, @albums[@choice])
      puts(@track_result)
      end
    end
  end
end
# Show is a method that loops through update and draw

MusicPlayerMain.new.show
