defmodule UntilMidnightWeb.PageController do
  use UntilMidnightWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
