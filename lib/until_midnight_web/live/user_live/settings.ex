defmodule UntilMidnightWeb.UserLive.Settings do
  use UntilMidnightWeb, :live_view

  alias UntilMidnight.Accounts
  alias UntilMidnight.Accounts.User

  @impl true
  def mount(_params, session, socket) do
    socket =  assign_defaults(session, socket)

    changeset = Accounts.change_user(socket.assigns.current_user)

    {:ok,
      socket
      |> assign(changeset: changeset)
      |> assign(page_title: "Edit User")
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

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.update_user(socket.assigns.current_user, user_params) do
      {:ok, _user} ->
        {:noreply,
          socket
          |> put_flash(:info, "User edited successfully")
          |> redirect(to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
