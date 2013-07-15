class GamesController < ApplicationController
  def index
  end

  def level
    client = Soundcloud.new(:client_id => ENV['SOUNDCLOUD_KEY'])
    @id = params[:id].to_i

    # Load API query once when game starts at level 1
    if @id == 1
      $available_tracks = []
      all_tracks = client.get('/tracks', :limit => 100, :order => 'created_at')
      all_tracks.each do |track|
        if track.genre && track.genre != '' && track.uri != ''
          $available_tracks << track
        end
      end
    end

    # Setting current track's info
    @current_track = $available_tracks[@id]
    @current_track_genre = @current_track.genre.capitalize

    # Grab three different genre types as answer choices
    @genre_list = Genre.all.shuffle!.first(3) ###################### Need to find current genre and avoid duplicate

    # Set up embed frame
    embed_info = client.get('/oembed', :url => @current_track.uri)
    @widget = embed_info['html']

    # Points score
    $points = 10
    $points += @id
  end

  def add_points

  end

  def score
  end
end
