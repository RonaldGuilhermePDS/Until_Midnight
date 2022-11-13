defmodule UntilMidnightWeb.PageLive do
  use UntilMidnightWeb, :live_view

  alias UntilMidnight.Accounts
  alias UntilMidnight.Accounts.User

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)

    changeset = Accounts.change_user_registration(%User{})

    {:ok,
      socket
      |> assign(changeset: changeset)
      |> assign(trigger_submit: false)
    }
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      %User{}
      |> User.registration_changeset(user_params)
      |> Map.put(:action, :validate)

      :timer.sleep(8000)

      {:noreply, socket |> assign(changeset: changeset)}
  end

  def handle_event("save", _, socket) do
    {:noreply, assign(socket, trigger_submit: true)}
  end
end
