defmodule UntilMidnightWeb.PostLive.New do
  use UntilMidnightWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)

    {:ok,
      socket
      |> assign(page_title: "New Post")}
  end
end
