defmodule UntilMidnightWeb.UserLive.PassSettings do
  use UntilMidnightWeb, :live_view

  alias UntilMidnight.Accounts
  alias UntilMidnight.Uploaders.Avatar

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)

    settings_path = Routes.live_path(socket, UntilMidnightWeb.UserLive.Settings)
    pass_settings_path = Routes.live_path(socket, __MODULE__)

    user = socket.assigns.current_user

    {:ok,
      socket
      |> assign(settings_path: settings_path, pass_settings_path: pass_settings_path)
      |> assign(:page_title, "Change Password")
      |> assign(changeset: Accounts.change_user_password(user))}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    {:noreply,
      socket
      |> assign(current_uri_path: URI.parse(uri).path)}
  end

  @impl true
  def handle_event("save", %{"user" => params}, socket) do
    %{"current_password" => password} = params
    case Accounts.update_user_password(socket.assigns.current_user, password, params) do
      {:ok, _user} ->
        {:noreply,
          socket
          |> put_flash(:info, "Password updated successfully.")
          |> redirect(to: "/")}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
