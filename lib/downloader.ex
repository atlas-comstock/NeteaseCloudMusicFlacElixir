defmodule Downloader do
  @moduledoc """
  Documentation for Downloader.
  """

  def run(argv) do
    song_list = argv
    |> parse_args
    |> to_string
    |> fetch_song_list()
    |> download_songs
  end

  def download_songs([]) do
    []
  end

  def download_songs([song_name | song_list]) do
    IO.inspect song_name
    download_songs(song_list)
  end

  def download_songs(song_name) do
    IO.inspect "last"<>song_name
  end

  def fetch_song_list(url) do
    IO.puts url
    url
    |> String.replace("#", "")
    HTTPotion.get(url)
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

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean ],
                               aliases: [ h: :help ])
    case parse do
      { _, url, _ } -> IO.inspect url
    end
  end

end
