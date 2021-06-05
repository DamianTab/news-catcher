defmodule CatcherWeb.EtagHelper do

  def etag_matches?(conn, data) do
    etag = PhoenixETag.schema_etag(data)
    none_match = List.first Plug.Conn.get_req_header(conn, "if-none-match")
    if none_match && etag do
      none_match = Plug.Conn.Utils.list(none_match)
      ("*" in none_match && NaiveDateTime.to_string(data.inserted_at)) == NaiveDateTime.to_string(data.updated_at)
        || etag in none_match
    else
      true
    end
  end

end
