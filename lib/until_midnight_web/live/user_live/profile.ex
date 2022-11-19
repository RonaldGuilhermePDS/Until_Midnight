defmodule UntilMidnightWeb.UserLive.Profile do
  use UntilMidnightWeb, :live_view

  alias UntilMidnightWeb.UserLive.FollowComponent

  @impl true
  def mount(%{"name" => name}, session, socket) do
    socket = assign_defaults(session, socket)
    user = Accounts.profile(name)

    my_action = get_action(user, socket.assigns.current_user)

    {:ok,
      socket
      |> assign(my_action: my_action)
      |> assign(user: user)
      |> assign(page_title: "@#{user.name}")}
  end

  @impl true
  def handle_info({FollowComponent, :update_totals, updated_user}, socket) do
    {:noreply, socket |> assign(user: updated_user)}
  end

  defp get_action(user, current_user) do
    cond do
      current_user && current_user == user -> :edit_profile
      current_user -> :follow_component
      true -> :login_btn
    end
  end
end
