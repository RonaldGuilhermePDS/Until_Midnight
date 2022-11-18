defmodule UntilMidnightWeb.UserLive.Settings do
  use UntilMidnightWeb, :live_view

  alias UntilMidnight.Accounts
  alias UntilMidnight.Accounts.User
  alias UntilMidnight.Uploaders.Avatar

  @extensions_whitelist ~w(.jpg .jpeg .png)

  @impl true
  def mount(_params, session, socket) do
    socket =  assign_defaults(session, socket)

    changeset = Accounts.change_user(socket.assigns.current_user)

    settings_path = Routes.live_path(socket, __MODULE__)
    pass_settings_path = Routes.live_path(socket, UntilMidnightWeb.UserLive.PassSettings)

    {:ok,
      socket
      |> assign(changeset: changeset)
      |> assign(page_title: "Edit User")
      |> assign(settings_path: settings_path, pass_settings_path: pass_settings_path)
      |> allow_upload(:avatar,
        accept: @extensions_whitelist,
        max_file_size: 9_000_000,
        progress: &handle_progress/3,
        auto_upload: true)
    }
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.current_user
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(changeset: changeset)}
  end

  def handle_event("upload_avatar", _params, socket) do
    {:noreply, socket}
  end

  defp handle_progress(:avatar, entry, socket) do
    if entry.done? do
      avatar = Avatar.get_avatar(socket, entry)
      user_params = %{"avatar" => avatar}
      case Accounts.update_user(socket.assigns.current_user, user_params) do
        {:ok, _user} ->
          Avatar.update(socket, socket.assigns.current_user.avatar, entry)
          current_user = Accounts.get_user!(socket.assigns.current_user.id)
          {:noreply,
            socket
            |> put_flash(:info, "Avatar updated successfully")
            |> assign(current_user: current_user)}
        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
      end
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.update_user(socket.assigns.current_user, user_params) do
      {:ok, _user} ->
        {:noreply,
          socket
          |> put_flash(:info, "User updated successfully")
          |> redirect(to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
