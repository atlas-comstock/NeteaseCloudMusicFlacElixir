defmodule Song_info do
  @baiduURL "http://sug.music.baidu.com/info/suggestion"
  @downloadLink "http://music.baidu.com/data/music/fmlink"

  def get_song_info(song_name) do
    song_name = song_name |> to_string
    query = 
      %{"word" => song_name, "version" => 2, "from" => 0}
      |> URI.encode_query()

    IO.puts @baiduURL <> "?#{query}"
    case( 
      @baiduURL <> "?#{query}"
      |> HTTPotion.get()
      |> Map.fetch(:body)
    ) do
      {:ok, body} -> body |> Poison.decode
      {:error, reason} -> IO.puts "error get_song_info #{reason}"
    end
  end

  def get_song_id({:error, reason}) do
    IO.puts "error get_song_id #{reason}"
  end

  def get_song_id({:ok, song_info}) do
    song_id_info = cond do
      song_info == nil -> IO.puts "song_info nil"
      song_info["data"] == nil -> IO.puts "song_info[data] nil"
      true -> song_info["data"]["song"] |> Enum.at(0) |> Map.fetch("songid")
    end

    case song_id_info do
      {:ok, song_id} -> song_id
      {:error, reason} -> IO.puts "error get_song_id #{reason}"
    end
  end

  def get_download_url_info(song_id) do
    query = 
      %{"songIds" => song_id, "type" => "flac"}
      |> URI.encode_query()

    IO.puts @downloadLink <> "?#{query}"
    case( 
      @downloadLink <> "?#{query}"
      |> HTTPotion.get()
      |> Map.fetch(:body)
    ) do
      {:ok, body} -> body
      {:error, reason} -> IO.puts "error get_song_info #{reason}"
    end
  end

  def get_song_detail({:error, reason}) do
    IO.puts "error get_song_detail #{reason}"
  end

  def get_song_detail({:ok, download_url_info}) do
    song_link_info = cond do
      download_url_info == nil -> IO.puts "song_info nil"
      download_url_info["data"] == nil -> IO.puts "song_info[data] nil"
      true -> 
        song_detail = download_url_info["data"]["songList"] |> Enum.at(0)
        %{
          "song_link" =>  song_detail["songLink"],
          "song_name" =>  song_detail["songName"] || "noname",
          "artist_name" => song_detail["artistName"] || "noname",
        }
    end
  end

end
