defmodule CatcherWeb.EtagHelper do

  def etag_matches?(conn, data) do
    etag = PhoenixETag.schema_etag(data)
    if_match = List.first Plug.Conn.get_req_header(conn, "if-match")
    if if_match && etag do
      if_match = Plug.Conn.Utils.list(if_match)
      ("*" in if_match || etag in if_match)
    else
      false
    end
  end

end
