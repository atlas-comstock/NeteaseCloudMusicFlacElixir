defmodule Downloader do
  @moduledoc """
  Documentation for Downloader.
  """
  @baiduURL "http://sug.music.baidu.com/info/suggestion"

  def run(argv) do
  argv
    |> parse_args
    |> to_string
    |> fetch_song_list
    |> download_songs
  end

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
      {:ok, body} -> body
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
      {:ok, song_id} -> song_id |> IO.puts
      {:error, reason} -> IO.puts "error get_song_id #{reason}"
    end
  end

  def get_download_url() do
  end

  def download_songs([]) do [] end

  def download_songs([song_name | song_list]) do
    IO.puts "song_name #{song_name}"
    get_song_info(song_name)
    |> Poison.decode
    |> get_song_id
    # download_songs(song_list)
  end

  def download_songs(song_name) do
    IO.inspect "last"<>song_name
  end

  def fetch_song_list(url) do
    IO.puts url
    url
    |> String.replace("#", "")
    |> HTTPotion.get!()
    |> handle_response()
    |> ( &Regex.scan(~r/<ul class=\"f-hide\">(.*?)<\/ul>/sm, &1) ).()
    |> to_string
    |> ( &Regex.scan(~r/<li><a .*?>(.*?)<\/a><\/li>/sm, &1, capture: :all_but_first)).()
  end

  def handle_response({:ok, %HTTPotion.Response{status_code: 200, headers: _, body: body}}) do
    body
  end

  def handle_response(%{body: body, headers: _, status_code: _}) do
    body
  end

  def handle_response(message) do
   raise  message
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean ],
                               aliases: [ h: :help ])
    case parse do
      { _, url, _ } -> IO.inspect url
    end
  end

end
