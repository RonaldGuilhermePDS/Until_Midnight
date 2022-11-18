defmodule UntilMidnightWeb.UserLive.Profile do
  use UntilMidnightWeb, :live_view

  @impl true
  def mount(%{"name" => name}, session, socket) do
    socket = assign_defaults(session, socket)

    {:ok,
      socket
      |> assign(name: name)}
  end
end
