defmodule Songlist do
  def fetch_song_list(url) do
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
end
