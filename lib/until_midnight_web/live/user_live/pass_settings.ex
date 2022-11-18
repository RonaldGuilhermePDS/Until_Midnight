defmodule UntilMidnightWeb.UserLive.PassSettings do
  use UntilMidnightWeb, :live_view

  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)

    settings_path = Routes.live_path(socket, UntilMidnightWeb.UserLive.Settings)
    pass_settings_path = Routes.live_path(socket, __MODULE__)

    {:ok,
      socket
      |> assign(settings_path: settings_path, pass_settings_path: pass_settings_path)}
  end
end
