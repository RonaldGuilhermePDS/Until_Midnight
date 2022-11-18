defmodule UntilMidnightWeb.UserLive.FollowComponent do
  use UntilMidnightWeb, :live_component

  def render(assigns) do
    ~L"""
      <button
        phx-target="<%= @myself %>"
        phx-click="toggle-status"
        class="<%= @follow_btn_styles? %>"><%= @follow_btn_name? %></button>
    """
  end

  def handle_event("toggle-status", _params, socket) do
    follow_btn_name? = get_follow_btn_name?(socket.assigns.follow_btn_name?)
    follow_btn_styles? = get_follow_btn_styles?(socket.assigns.follow_btn_name?)

    :timer.sleep(200)

    {:noreply,
      socket
      |> assign(follow_btn_name?: follow_btn_name?)
      |> assign(follow_btn_styles?: follow_btn_styles?)}
  end

  defp get_follow_btn_name?(name) when name == "Follow" do
    "Unfollow"
  end

  defp get_follow_btn_name?(name) when name == "Unfollow" do
    "Follow"
  end

  defp get_follow_btn_styles?(name) when name == "Follow"  do
    "py-1 px-2 text-red-500 border-2 rounded font-semibold hover:bg-gray-50 focus:outline-none"
  end

  defp get_follow_btn_styles?(name) when name == "Unfollow" do
    "py-1 px-5 border-none shadow rounded text-gray-50 hover:bg-light-blue-600 bg-light-blue-500 focus:outline-none"
  end
end
