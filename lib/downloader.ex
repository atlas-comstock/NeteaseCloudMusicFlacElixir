defmodule Downloader do
  @moduledoc """
  Documentation for Downloader.
  """

  def run(argv) do
  argv
    |> parse_args
    |> to_string
    |> Songlist.fetch_song_list
    |> SongDownloader.download_songs
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean ],
                               aliases: [ h: :help ])
    case parse do
      { _, url, _ } -> IO.inspect url
    end
  end

end
