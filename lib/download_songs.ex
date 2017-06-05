defmodule SongDownloader do
  @min_size 10

  def download_songs([]) do [] end

  def download_songs([song_name | song_list]) do
    IO.puts "song_name #{song_name}"
    Song_info.get_song_info(song_name)
    |> Song_info.get_song_id
    |> Song_info.get_download_url_info
    |> Poison.decode
    |> Song_info.get_song_detail
    |> startDownload
    download_songs(song_list)
  end

  def startDownload(%{"song_link"=> ""}) do IO.puts "can not find song link" end
  def startDownload(%{"song_link"=> song_link, "song_name"=> song_name, "artist_name"=> artist_name})
  do
    IO.puts "\nsong_link is #{song_link}, song_name: #{song_name}, artist_name: #{artist_name}" 
    song_dir = "song_dir"
    File.mkdir(song_dir)
    filename = 
      Path.join([System.cwd(), song_dir, "#{song_name}-#{artist_name}"]) 
      |> String.replace(" ", "")
      |> String.replace(",", "-")
    IO.puts filename

    %{body: body, headers: headers} = 
      song_link
      |> HTTPotion.get()

    content_size = 
      headers["content-length"] 
      |> Integer.parse() |> elem(0) 
      |> div(:math.pow(1024, 2) |> round) 

    cond do
      File.exists?(filename) ->
        IO.puts "#{song_name} is already downloaded. Finding next song...\n\n"
      (content_size < @min_size) ->
        IO.puts "the size of #{filename} (#{content_size} Mb) is less than 10 Mb, skipping"
      true ->
        {:ok, file} = File.open filename, [:write]
        IO.binwrite file, body
    end

  end
end
