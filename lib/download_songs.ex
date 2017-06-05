defmodule SongDownloader do
  def download_songs([]) do [] end

  def download_songs([song_name | song_list]) do
    IO.puts "song_name #{song_name}"
    Song_info.get_song_info(song_name)
    |> Poison.decode
    |> Song_info.get_song_id
    |> Song_info.get_download_url_info
    |> Poison.decode
    |> Song_info.get_song_detail
    |> startDownload
    # download_songs(song_list)
  end

  def startDownload(%{"song_link"=> song_link, "song_name"=> song_name, "artist_name"=> artist_name})
  do
    IO.puts song_name
    IO.puts artist_name
  end
end
